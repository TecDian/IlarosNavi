----------------------------------------------------------------------------
-- IlarosNavi
-- Hauptmodul
-- Die Funktionen IlarosNavi:AddZWaypoint() und IlarosNavi:RemoveWaypoint()
-- stehen öffentlich für andere Addons zur Verfügung.
----------------------------------------------------------------------------

-- Einfache Lokalisierungstabelle für Texte
local L = IlarosNaviLocals
-- Icondarstellung auf den Karten
local Astrolabe = DongleStub("Astrolabe-0.4")
-- Versionsverwaltung
local ldb = LibStub("LibDataBroker-1.1")

-- Minimap schneller erneuern
Astrolabe.MinimapUpdateTime = 0.1

-- Addon-Objekt erzeugen, "IlarosNavi" kann von anderen Addons abgefragt werden
IlarosNavi = {
    events = {},
    eventFrame = CreateFrame("Frame"),
    RegisterEvent = function(self, event, method)
        self.eventFrame:RegisterEvent(event)
        self.events[event] = method or event
    end,
    UnregisterEvent = function(self, event)
        self.eventFrame:UnregisterEvent(event)
        self.events[event] = nil
    end,
    version = GetAddOnMetadata("IlarosNavi", "Version")
}

IlarosNavi.eventFrame:SetScript("OnEvent", function(self, event, ...)
    local method = IlarosNavi.events[event]
    if method and IlarosNavi[method] then
        IlarosNavi[method](IlarosNavi, event, ...)
    end
end)

IlarosNavi:RegisterEvent("ADDON_LOADED")

-- Lokale Definitionen
local GetCurrentCursorPosition
local WorldMap_OnUpdate
local Block_OnClick,Block_OnUpdate,BlockOnEnter,BlockOnLeave
local Block_OnDragStart,Block_OnDragStop
local callbackTbl
local RoundCoords
local waypoints = {}

function IlarosNavi:ADDON_LOADED(event, addon)
    if addon == "IlarosNavi" then
        self:UnregisterEvent("ADDON_LOADED")
        self.defaults = {
            profile = {
                general = {
                    confirmremoveall = true,
                    announce = false,
                    corpse_arrow = true,
                },
                block = {
                    enable = true,
                    accuracy = 2,
                    bordercolor = {1, 0.8, 0, 0.8},
                    bgcolor = {0, 0, 0, 0.4},
                    lock = false,
                    height = 30,
                    width = 100,
                    fontsize = 12,
                },
                mapcoords = {
                    playerenable = false,
                    playeraccuracy = 2,
                    cursorenable = false,
                    cursoraccuracy = 2,
                },
                arrow = {
                    enable = true,
                    goodcolor = {0, 1, 0},
                    badcolor = {1, 0, 0},
                    middlecolor = {1, 1, 0},
                    arrival = 15,
                    lock = false,
                    noclick = false,
                    showtta = true,
                    autoqueue = true,
                    menu = true,
                    scale = 1.0,
                    alpha = 1.0,
                    title_width = 0,
                    title_height = 0,
                    title_scale = 1,
                    title_alpha = 1,
                    setclosest = true,
                    enablePing = false,
                },
                minimap = {
                    enable = true,
                    otherzone = true,
                    tooltip = true,
                    menu = true,
                },
                worldmap = {
                    enable = true,
                    tooltip = true,
                    otherzone = true,
                    clickcreate = true,
                    menu = true,
                    create_modifier = "C",
                },
                comm = {
                    enable = true,
                    prompt = false,
                },
                persistence = {
                    cleardistance = 10,
                    savewaypoints = true,
                },
                feeds = {
                    coords = false,
                    coords_throttle = 0.3,
                    coords_accuracy = 2,
                    arrow = false,
                    arrow_throttle = 0.1,
                },
                poi = {
                    enable = true,
                    modifier = "C",
                    setClosest = false,
                },
            },
        }

        self.waydefaults = {
            profile = {
                ["*"] = {},
            },
        }

        self.db = LibStub("AceDB-3.0"):New("NaviConfig", self.defaults, "Default")
        self.waydb = LibStub("AceDB-3.0"):New("NaviMarks", self.waydefaults)

        self.db.RegisterCallback(self, "OnProfileChanged", "ReloadOptions")
        self.db.RegisterCallback(self, "OnProfileCopied", "ReloadOptions")
        self.db.RegisterCallback(self, "OnProfileReset", "ReloadOptions")
        self.waydb.RegisterCallback(self, "OnProfileChanged", "ReloadWaypoints")
        self.waydb.RegisterCallback(self, "OnProfileCopied", "ReloadWaypoints")
        self.waydb.RegisterCallback(self, "OnProfileReset", "ReloadWaypoints")

        self.tooltip = CreateFrame("GameTooltip", "IlarosNaviTooltip", nil, "GameTooltipTemplate")
        self.tooltip:SetFrameStrata("DIALOG")

        self.dropdown = CreateFrame("Frame", "IlarosNaviDropdown", nil, "UIDropDownMenuTemplate")

        self.waypoints = waypoints
        self.waypointprofile = self.waydb.profile

        self:RegisterEvent("PLAYER_LEAVING_WORLD")
        self:RegisterEvent("PLAYER_ENTERING_WORLD", "ZoneChanged")
        self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "ZoneChanged")
        self:RegisterEvent("WORLD_MAP_UPDATE", "ZoneChanged")
        self:RegisterEvent("CHAT_MSG_ADDON")

        self:ReloadOptions()
        self:ReloadWaypoints()

        if self.db.profile.feeds.coords then
            -- Create a data feed for coordinates
            local feed_coords = ldb:NewDataObject("IlarosNavi_Coords", {
                type = "data source",
                icon = "Interface\\Icons\\INV_Misc_Map_01",
                text = "",
            })

            local coordFeedFrame = CreateFrame("Frame")
            local throttle, counter = self.db.profile.feeds.coords_throttle, 0

            function IlarosNavi:UpdateCoordFeedThrottle()
                throttle = self.db.profile.feeds.coords_throttle
            end

            coordFeedFrame:SetScript("OnUpdate", function(self, elapsed)
                counter = counter + elapsed
                if counter < throttle then
                    return
                end

                counter = 0
                local c,z,x,y = Astrolabe:GetCurrentPlayerPosition()
                local opt = IlarosNavi.db.profile

                if x and y then
                    feed_coords.text = string.format("%s", RoundCoords(x, y, opt.feeds.coords_accuracy))
                end
            end)
        end
    end
end

function IlarosNavi:ReloadOptions()
    -- This handles the reloading of all options
    self.profile = self.db.profile

    self:ShowHideWorldCoords()
    self:ShowHideCoordBlock()
    self:ShowHideCrazyArrow()
    self:EnableDisablePOIIntegration()
end

function IlarosNavi:ReloadWaypoints()
    local pc, pz = GetCurrentMapContinent(), GetCurrentMapZone()

    for uid,value in pairs(waypoints) do
        self:ClearWaypoint(uid)
    end

    waypoints = {}
    self.waypoints = waypoints
    self.waypointprofile = self.waydb.profile

    for zone,data in pairs(self.waypointprofile) do
        local c,z = self:GetCZ(zone)
        local same = (c == pc) and (z == pz)
        local minimap = self.profile.minimap.enable and (self.profile.minimap.otherzone or same)
        local world = self.profile.worldmap.enable and (self.profile.worldmap.otherzone or same)
        for idx,waypoint in ipairs(data) do
            local coord,title = waypoint:match("^(%d+):(.*)$")
            if not title:match("%S") then title = nil end
            local x,y = self:GetXY(coord)
            self:AddZWaypoint(c, z, x*100, y*100, title, false, minimap, world, nil, true)
        end
    end
end

function IlarosNavi:ZoneChanged()
    -- Update the visibility of the coordinate box
    self:ShowHideCoordBlock()
end

-- Hook some global functions so we know when the world map size changes
local mapSizedUp = not (WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE);
hooksecurefunc("WorldMap_ToggleSizeUp", function()
    mapSizedUp = true
    IlarosNavi:ShowHideWorldCoords()
end)
hooksecurefunc("WorldMap_ToggleSizeDown", function()
    mapSizedUp = false
    IlarosNavi:ShowHideWorldCoords()
end)

function IlarosNavi:ShowHideWorldCoords()
    -- Bail out if we're not supposed to be showing this frame
    if self.profile.mapcoords.playerenable or self.db.profile.mapcoords.cursorenable then
        -- Create the frame if it doesn't exist
        if not IlarosNaviWorldFrame then
            IlarosNaviWorldFrame = CreateFrame("Frame", nil, WorldMapFrame)
            IlarosNaviWorldFrame.Player = IlarosNaviWorldFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            IlarosNaviWorldFrame.Cursor = IlarosNaviWorldFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            IlarosNaviWorldFrame:SetScript("OnUpdate", WorldMap_OnUpdate)
        end

        if mapSizedUp then
            IlarosNaviWorldFrame.Player:SetPoint("RIGHT", WorldMapPositioningGuide, "BOTTOM", -15, 15)
            IlarosNaviWorldFrame.Cursor:SetPoint("LEFT", WorldMapPositioningGuide, "BOTTOM", 15, 15)
        else
            IlarosNaviWorldFrame.Player:SetPoint("RIGHT", WorldMapPositioningGuide, "BOTTOM", -40, 2)
            IlarosNaviWorldFrame.Cursor:SetPoint("LEFT", WorldMapPositioningGuide, "BOTTOM", -15, 2)
        end

        IlarosNaviWorldFrame.Player:Hide()
        IlarosNaviWorldFrame.Cursor:Hide()

        if self.profile.mapcoords.playerenable then
            IlarosNaviWorldFrame.Player:Show()
        end

        if self.profile.mapcoords.cursorenable then
            IlarosNaviWorldFrame.Cursor:Show()
        end

        -- Show the frame
        IlarosNaviWorldFrame:Show()
    elseif IlarosNaviWorldFrame then
        IlarosNaviWorldFrame:Hide()
    end
end

function IlarosNavi:ShowHideCoordBlock()
    -- Bail out if we're not supposed to be showing this frame
    if self.profile.block.enable then
        -- Create the frame if it doesn't exist
        if not IlarosNaviBlock then
            -- Create the coordinate display
            IlarosNaviBlock = CreateFrame("Button", "IlarosNaviBlock", UIParent)
            IlarosNaviBlock:SetWidth(120)
            IlarosNaviBlock:SetHeight(32)
            IlarosNaviBlock:SetToplevel(1)
            IlarosNaviBlock:SetFrameStrata("LOW")
            IlarosNaviBlock:SetMovable(true)
            IlarosNaviBlock:EnableMouse(true)
            IlarosNaviBlock:SetClampedToScreen()
            IlarosNaviBlock:RegisterForDrag("LeftButton")
            IlarosNaviBlock:RegisterForClicks("RightButtonUp")
            IlarosNaviBlock:SetPoint("TOP", Minimap, "BOTTOM", -20, -10)

            IlarosNaviBlock.Text = IlarosNaviBlock:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            IlarosNaviBlock.Text:SetJustifyH("CENTER")
            IlarosNaviBlock.Text:SetPoint("CENTER", 0, 0)

            IlarosNaviBlock:SetBackdrop({
                bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
                edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
                edgeSize = 16,
                insets = {left = 4, right = 4, top = 4, bottom = 4},
            })
            IlarosNaviBlock:SetBackdropColor(0,0,0,0.4)
            IlarosNaviBlock:SetBackdropBorderColor(1,0.8,0,0.8)

            -- Set behavior scripts
            IlarosNaviBlock:SetScript("OnUpdate", Block_OnUpdate)
            IlarosNaviBlock:SetScript("OnClick", Block_OnClick)
            IlarosNaviBlock:SetScript("OnEnter", Block_OnEnter)
            IlarosNaviBlock:SetScript("OnLeave", Block_OnLeave)
            IlarosNaviBlock:SetScript("OnDragStop", Block_OnDragStop)
            IlarosNaviBlock:SetScript("OnDragStart", Block_OnDragStart)
        end
        -- Show the frame
        IlarosNaviBlock:Show()

        local opt = self.profile.block

        -- Update the backdrop color, and border color
        IlarosNaviBlock:SetBackdropColor(unpack(opt.bgcolor))
        IlarosNaviBlock:SetBackdropBorderColor(unpack(opt.bordercolor))

        -- Update the height and width
        IlarosNaviBlock:SetHeight(opt.height)
        IlarosNaviBlock:SetWidth(opt.width)

        -- Update the font size
        local font,height = IlarosNaviBlock.Text:GetFont()
        IlarosNaviBlock.Text:SetFont(font, opt.fontsize, select(3, IlarosNaviBlock.Text:GetFont()))

    elseif IlarosNaviBlock then
        IlarosNaviBlock:Hide()
    end
end

-- Hook the WorldMap OnClick
local world_click_verify = {
    ["A"] = function() return IsAltKeyDown() end,
    ["C"] = function() return IsControlKeyDown() end,
    ["S"] = function() return IsShiftKeyDown() end,
}

local origScript = WorldMapButton_OnClick
WorldMapButton_OnClick = function(self, ...)
    local mouseButton, button = ...
    if mouseButton == "RightButton" then
        -- Check for all the modifiers that are currently set
        for mod in IlarosNavi.db.profile.worldmap.create_modifier:gmatch("[ACS]") do
            if not world_click_verify[mod] or not world_click_verify[mod]() then
                return origScript and origScript(self, ...) or true
            end
        end

        -- Actually try to add a note
        local c,z = GetCurrentMapContinent(), GetCurrentMapZone()
        local x,y = GetCurrentCursorPosition()

        if z == 0 then
            return origScript and origScript(self, ...) or true
        end

        local uid = IlarosNavi:AddZWaypoint(c,z,x*100,y*100)
    else
        return origScript and origScript(self, ...) or true
    end
end

if WorldMapButton:GetScript("OnMouseUp") == origScript then
    WorldMapButton:SetScript("OnMouseUp", WorldMapButton_OnClick)
end

local function WaypointCallback(event, arg1, arg2, arg3)
    if event == "OnDistanceArrive" then
        IlarosNavi:ClearWaypoint(arg1)
    elseif event == "OnTooltipShown" then
        local tooltip = arg1
        if arg3 then
            tooltip:SetText(L["IlarosNavi waypoint"])
            tooltip:AddLine(string.format(L["%s yards away"], math.floor(arg2)), 1, 1 ,1)
            tooltip:Show()
        else
            tooltip.lines[2]:SetFormattedText(L["%s yards away"], math.floor(arg2), 1, 1, 1)
        end
    end
end

--[[-------------------------------------------------------------------
--  Dropdown menu code
-------------------------------------------------------------------]]--

StaticPopupDialogs["IlarosNavi_REMOVE_ALL_CONFIRM"] = {
    text = L["Are you sure you would like to remove ALL IlarosNavi waypoints?"],
    button1 = L["Yes"],
    button2 = L["No"],
    OnAccept = function()
        IlarosNavi.waydb:ResetProfile()
        IlarosNavi:ReloadWaypoints()
        NaviText_Echo(NaviText_WPUnsetAll)
    end,
    timeout = 30,
    whileDead = 1,
    hideOnEscape = 1,
}

local dropdown_info = {
    -- Define level one elements here
    [1] = {
        { -- Title
            text = L["Waypoint Options"],
            isTitle = 1,
        },
        {
            -- set as crazy arrow
            text = L["Set as waypoint arrow"],
            func = function()
                local uid = IlarosNavi.dropdown.uid
                local data = waypoints[uid]
                IlarosNavi:SetCrazyArrow(uid, IlarosNavi.profile.arrow.arrival, data.title or L["IlarosNavi waypoint"])
            end,
        },
        {
            -- Send waypoint
            text = L["Send waypoint to"],
            hasArrow = true,
            value = "send",
        },
        { -- Remove waypoint
            text = L["Remove waypoint"],
            func = function()
                local uid = IlarosNavi.dropdown.uid
                local data = waypoints[uid]
                IlarosNavi:RemoveWaypoint(uid)
                local msg = string.format(NaviText_WPUnset, data.title and "'"..data.title.."' " or "", data.x, data.y, data.zone)
                NaviText_Echo(msg)
            end,
        },
        { -- Remove all waypoints from this zone
            text = L["Remove all waypoints from this zone"],
            func = function()
                local uid = IlarosNavi.dropdown.uid
                local data = waypoints[uid]
                for uid in pairs(waypoints[data.zone]) do
                    IlarosNavi:RemoveWaypoint(uid)
                end
                NaviText_Echo(NaviText_WPUnsetZone:format(data.zone))
            end,
        },
        { -- Remove ALL waypoints
            text = L["Remove all waypoints"],
            func = function()
                if IlarosNavi.db.profile.general.confirmremoveall then
                    StaticPopup_Show("IlarosNavi_REMOVE_ALL_CONFIRM")
                else
                    StaticPopupDialogs["IlarosNavi_REMOVE_ALL_CONFIRM"].OnAccept()
                    return
                end
            end,
        },
        { -- Save this waypoint
            text = L["Save this waypoint between sessions"],
            checked = function()
                return IlarosNavi:UIDIsSaved(IlarosNavi.dropdown.uid)
            end,
            func = function()
                -- Check to see if it's already saved
                local uid = IlarosNavi.dropdown.uid
                if IlarosNavi:UIDIsSaved(uid) then
                    local data = waypoints[uid]
                    if data then
                        local key = string.format("%d:%s", data.coord, data.title or "")
                        local zone = data.zone
                        local sv = IlarosNavi.waypointprofile[zone]

                        -- Find the entry in the saved variable
                        for idx,entry in ipairs(sv) do
                            if entry == key then
                                table.remove(sv, idx)
                                return
                            end
                        end
                    end
                else
                    local data = waypoints[uid]
                    if data then
                        local key = string.format("%d:%s", data.coord, data.title or "")
                        local zone = data.zone
                        local sv = IlarosNavi.waypointprofile[zone]
                        table.insert(sv, key)
                    end
                end
            end,
        },
    },
    [2] = {
        send = {
            {
                -- Title
                text = L["Waypoint communication"],
                isTitle = true,
            },
            {
                -- Party
                text = L["Send to party"],
                func = function()
                    IlarosNavi:SendWaypoint(IlarosNavi.dropdown.uid, "PARTY")
                end
            },
            {
                -- Raid
                text = L["Send to raid"],
                func = function()
                    IlarosNavi:SendWaypoint(IlarosNavi.dropdown.uid, "RAID")
                end
            },
            {
                -- Battleground
                text = L["Send to battleground"],
                func = function()
                    IlarosNavi:SendWaypoint(IlarosNavi.dropdown.uid, "BATTLEGROUND")
                end
            },
            {
                -- Guild
                text = L["Send to guild"],
                func = function()
                    IlarosNavi:SendWaypoint(IlarosNavi.dropdown.uid, "GUILD")
                end
            },
        },
    },
}

local function init_dropdown(self, level)
    -- Make sure level is set to 1, if not supplied
    level = level or 1

    -- Get the current level from the info table
    local info = dropdown_info[level]

    -- If a value has been set, try to find it at the current level
    if level > 1 and UIDROPDOWNMENU_MENU_VALUE then
        if info[UIDROPDOWNMENU_MENU_VALUE] then
            info = info[UIDROPDOWNMENU_MENU_VALUE]
        end
    end

    -- Add the buttons to the menu
    for idx,entry in ipairs(info) do
        if type(entry.checked) == "function" then
            -- Make this button dynamic
            local new = {}
            for k,v in pairs(entry) do new[k] = v end
            new.checked = new.checked()
            entry = new
        else
            entry.checked = nil
        end

        UIDropDownMenu_AddButton(entry, level)
    end
end

function IlarosNavi:InitializeDropdown(uid)
    self.dropdown.uid = uid
    UIDropDownMenu_Initialize(self.dropdown, init_dropdown)
end

function IlarosNavi:UIDIsSaved(uid)
    local data = waypoints[uid]
    if data then
        local key = string.format("%d:%s", data.coord, data.title or "")
        local zone = data.zone
        local sv = IlarosNavi.waypointprofile[zone]

        -- Find the entry in the saved variable
        for idx,entry in ipairs(sv) do
            if entry == key then
                return true
            end
        end
    end
    return false
end

function IlarosNavi:SendWaypoint(uid, channel)
    local data = waypoints[uid]
    local msg = string.format("%s:%d:%s", data.zone, data.coord, data.title or "")
    SendAddonMessage("IlarosNavi2", msg, channel)
end

function IlarosNavi:CHAT_MSG_ADDON(event, prefix, data, channel, sender)
    if prefix ~= "IlarosNavi2" then return end
    if sender == UnitName("player") then return end

    local zone,coord,title = string.split(":", data)
    if not title:match("%S") then
        title = string.format(L["Waypoint from %s"], sender)
    end

    local c,z = self:GetCZ(zone)
    local x,y = self:GetXY(tonumber(coord))
    self:AddZWaypoint(c, z, x*100, y*100, title)
    local msg = string.format(NaviText_WPSent, title, zone, sender)
    NaviText_Echo(msg)
end

--[[-------------------------------------------------------------------
--  Define callback functions
-------------------------------------------------------------------]]--
local function _minimap_onclick(event, uid, self, button)
    if IlarosNavi.db.profile.minimap.menu then
        IlarosNavi:InitializeDropdown(uid)
        ToggleDropDownMenu(1, nil, IlarosNavi.dropdown, "cursor", 0, 0)
    end
end

local function _world_onclick(event, uid, self, button)
    if IlarosNavi.db.profile.worldmap.menu then
        IlarosNavi:InitializeDropdown(uid)
        ToggleDropDownMenu(1, nil, IlarosNavi.dropdown, "cursor", 0, 0)
    end
end

local function _both_tooltip_show(event, tooltip, uid, dist)
    local data = waypoints[uid]

    tooltip:SetText(data.title or L["IlarosNavi waypoint"])
    if dist and tonumber(dist) then
        tooltip:AddLine(string.format(L["%s yards away"], math.floor(dist)), 1, 1, 1)
    else
        tooltip:AddLine(L["Unknown distance"])
    end
    tooltip:AddLine(string.format(L["%s (%.2f, %.2f)"], data.zone, data.x, data.y), 0.7, 0.7, 0.7)
    tooltip:Show()
end

local function _minimap_tooltip_show(event, tooltip, uid, dist)
    if not IlarosNavi.db.profile.minimap.tooltip then
        tooltip:Hide()
        return
    end
    return _both_tooltip_show(event, tooltip, uid, dist)
end

local function _world_tooltip_show(event, tooltip, uid, dist)
    if not IlarosNavi.db.profile.worldmap.tooltip then
        tooltip:Hide()
        return
    end
    return _both_tooltip_show(event, tooltip, uid, dist)
end

local function _both_tooltip_update(event, tooltip, uid, dist)
    if dist and tonumber(dist) then
        tooltip.lines[2]:SetFormattedText(L["%s yards away"], math.floor(dist), 1, 1, 1)
    else
        tooltip.lines[2]:SetText(L["Unknown distance"])
    end
end

local function _both_clear_distance(event, uid, range, distance, lastdistance)
    if not UnitOnTaxi("player") then
        IlarosNavi:RemoveWaypoint(uid)
    end
end

local function _both_ping_arrival(event, uid, range, distance, lastdistance)
    if IlarosNavi.profile.arrow.enablePing then
        PlaySoundFile("Interface\\AddOns\\IlarosNavi\\media\\ping.mp3")
    end
end

local function _remove(event, uid)
    local data = waypoints[uid]
    local key = string.format("%d:%s", data.coord, data.title or "")
    local zone = data.zone
    local sv = IlarosNavi.waypointprofile[zone]

    -- Find the entry in the saved variable
    for idx,entry in ipairs(sv) do
        if entry == key then
            table.remove(sv, idx)
            break
        end
    end

    -- Remove this entry from the waypoints table
    waypoints[uid] = nil
    if waypoints[zone] then
        waypoints[zone][uid] = nil
    end
end

local function noop() end

function IlarosNavi:RemoveWaypoint(uid)
    local data = waypoints[uid]
    self:ClearWaypoint(uid)

    if data then
        local key = string.format("%d:%s", data.coord, data.title or "")
        local zone = data.zone
        local sv = IlarosNavi.waypointprofile[zone]

        -- Find the entry in the saved variable
        for idx,entry in ipairs(sv) do
            if entry == key then
                table.remove(sv, idx)
                break
            end
        end
    end

    -- Remove this entry from the waypoints table
    waypoints[uid] = nil
    if data and data.zone and waypoints[data.zone] then
        waypoints[data.zone][uid] = nil
    end
end

-- TODO: Make this not suck
function IlarosNavi:AddWaypoint(x, y, desc, persistent, minimap, world, silent)
    local c,z = GetCurrentMapContinent(), GetCurrentMapZone()

    if not c or not z or c < 1 then
        --self:Print("Cannot find a valid zone to place the coordinates")
        return
    end

    return self:AddZWaypoint(c, z, x, y, desc, persistent, minimap, world, silent)
end

function IlarosNavi:AddZWaypoint(c, z, x, y, desc, persistent, minimap, world, custom_callbacks, silent, crazy)
    local callbacks
    if custom_callbacks then
        callbacks = custom_callbacks
    else
        callbacks = {
            minimap = {
                onclick = _minimap_onclick,
                tooltip_show = _minimap_tooltip_show,
                tooltip_update = _both_tooltip_update,
            },
            world = {
                onclick = _world_onclick,
                tooltip_show = _world_tooltip_show,
                tooltip_update = _both_tooltip_show,
            },
            distance = {
            },
        }
    end

    local cleardistance = self.profile.persistence.cleardistance
    local arrivaldistance = self.profile.arrow.arrival

    if cleardistance == arrivaldistance then
        callbacks.distance[cleardistance] = function(...)
            _both_clear_distance(...);
            _both_ping_arrival(...);
        end
    else
        if cleardistance > 0 then
            callbacks.distance[cleardistance] = _both_clear_distance
        end
        if arrivaldistance > 0 then
            callbacks.distance[arrivaldistance] = _both_ping_arrival
        end
    end


    -- Default values
    if persistent == nil then persistent = self.profile.persistence.savewaypoints end
    if minimap == nil then minimap = self.profile.minimap.enable end
    if world == nil then world = self.profile.worldmap.enable end
    if crazy == nil then crazy = self.profile.arrow.autoqueue end

    local coord = self:GetCoord(x / 100, y / 100)
    local zone = self:GetMapFile(c, z)

    if not zone then
        return
    end

    -- Ensure there isn't already a waypoint at this location
    if waypoints[zone] then
        for uid in pairs(waypoints[zone]) do
            local data = waypoints[uid]
            if data.title == desc and data.coord == coord then
                -- This is a duplicate waypoint, so return that uid
                return uid
            end
        end
    end

    local uid = self:SetWaypoint(c,z,x/100,y/100, callbacks, minimap, world)
    if crazy then
        self:SetCrazyArrow(uid, self.profile.arrow.arrival, desc)
    end

    waypoints[uid] = {
        title = desc,
        coord = coord,
        x = x,
        y = y,
        zone = zone,
    }

    if not waypoints[zone] then
        waypoints[zone] = {}
    end

    waypoints[zone][uid] = true

    -- If this is a persistent waypoint, then add it to the waypoints table
    if persistent then
        local data = string.format("%d:%s", coord, desc or "")
        table.insert(self.waypointprofile[zone], data)
    end

    if not silent and self.profile.general.announce then
        local ctxt = RoundCoords(x/100, y/100, 2)
        local msg = string.format(NaviText_WPSet, desc and "'"..desc.."' " or "", ctxt, zone)
        NaviText_Echo(msg)
    end

    return uid
end

function IlarosNavi:WaypointExists(c, z, x, y, desc)
    local coord = self:GetCoord(x / 100, y / 100)
    local zone = self:GetMapFile(c, z)

    if not zone then
        return
    end

    if waypoints[zone] then
        for uid in pairs(waypoints[zone]) do
            local data = waypoints[uid]
            if data.title == desc then
                return true
            else
                return false
            end
        end
    end
end

function IlarosNavi:SetCustomWaypoint(c,z,x,y,callback,minimap,world, silent)
    return self:AddZWaypoint(c, z, x, y, desc, false, minimap, world, callback, silent)
end

-- Code taken from HandyNotes, thanks Xinhuan
---------------------------------------------------------
-- Public functions for plugins to convert between MapFile <-> C,Z
--
local continentMapFile = {
    [WORLDMAP_COSMIC_ID] = "Cosmic", -- That constant is -1
    [0] = "World",
    [1] = "Kalimdor",
    [2] = "Azeroth",
    [3] = "Expansion01",
}
local reverseMapFileC = {}
local reverseMapFileZ = {}
for C = 1, #Astrolabe.ContinentList do
    for Z = 1, #Astrolabe.ContinentList[C] do
        local mapFile = Astrolabe.ContinentList[C][Z]
        reverseMapFileC[mapFile] = C
        reverseMapFileZ[mapFile] = Z
    end
end
for C = -1, 3 do
    local mapFile = continentMapFile[C]
    reverseMapFileC[mapFile] = C
    reverseMapFileZ[mapFile] = 0
end

function IlarosNavi:GetMapFile(C, Z)
    if not C or not Z then return end
    if Z == 0 then
        return continentMapFile[C]
    elseif C > 0 then
        return Astrolabe.ContinentList[C][Z]
    end
end
function IlarosNavi:GetCZ(mapFile)
    return reverseMapFileC[mapFile], reverseMapFileZ[mapFile]
end

-- Public functions for plugins to convert between coords <--> x,y
function IlarosNavi:GetCoord(x, y)
    return floor(x * 10000 + 0.5) * 10000 + floor(y * 10000 + 0.5)
end
function IlarosNavi:GetXY(id)
    return floor(id / 10000) / 10000, (id % 10000) / 10000
end

do
    -- Code courtesy ckknight
    function GetCurrentCursorPosition()
        local x, y = GetCursorPosition()
        local left, top = WorldMapDetailFrame:GetLeft(), WorldMapDetailFrame:GetTop()
        local width = WorldMapDetailFrame:GetWidth()
        local height = WorldMapDetailFrame:GetHeight()
        local scale = WorldMapDetailFrame:GetEffectiveScale()
        local cx = (x/scale - left) / width
        local cy = (top - y/scale) / height

        if cx < 0 or cx > 1 or cy < 0 or cy > 1 then
            return nil, nil
        end

        return cx, cy
    end

    local coord_fmt = "%%.%df, %%.%df"
    function RoundCoords(x,y,prec)
        local fmt = coord_fmt:format(prec, prec)
        return fmt:format(x*100, y*100)
    end

    function WorldMap_OnUpdate(self, elapsed)
        local c,z,x,y = Astrolabe:GetCurrentPlayerPosition()
        local opt = IlarosNavi.db.profile

        if not x or not y then
            self.Player:SetText("Player: ---")
        else
            self.Player:SetFormattedText("Player: %s", RoundCoords(x, y, opt.mapcoords.playeraccuracy))
        end

        local cX, cY = GetCurrentCursorPosition()

        if not cX or not cY then
            self.Cursor:SetText("Cursor: ---")
        else
            self.Cursor:SetFormattedText("Cursor: %s", RoundCoords(cX, cY, opt.mapcoords.cursoraccuracy))
        end
    end
end

do
    function Block_OnUpdate(self, elapsed)
        local c,z,x,y = Astrolabe:GetCurrentPlayerPosition()
        local opt = IlarosNavi.db.profile

        if not x or not y then
            -- Hide the frame when we have no coordinates
            self:Hide()
        else
            self.Text:SetFormattedText("%s", RoundCoords(x, y, opt.block.accuracy))
        end
    end

    function Block_OnDragStart(self, button, down)
        if not IlarosNavi.db.profile.block.lock then
            self:StartMoving()
        end
    end

    function Block_OnDragStop(self, button, down)
        self:StopMovingOrSizing()
    end

    function Block_OnClick(self, button, down)
        local c,z,x,y = Astrolabe:GetCurrentPlayerPosition()
        local zone = IlarosNavi:GetMapFile(c, z)
        local desc = format("%s: %.2f, %.2f", zone, x*100, y*100)
        IlarosNavi:AddZWaypoint(c, z, x*100, y*100, desc)
    end
end

local function usage()
    NaviText_Echo(L["|cffffff78IlarosNavi |r/Navi |cffffff78Usage:|r"])
    NaviText_Echo(L["|cffffff78/Navi <x> <y> [desc]|r - Adds a waypoint at x,y with descrtiption desc"])
    NaviText_Echo(L["|cffffff78/Navi <zone> <x> <y> [desc]|r - Adds a waypoint at x,y in zone with description desc"])
    NaviText_Echo(L["|cffffff78/Navi reset all|r - Resets all waypoints"])
    NaviText_Echo(L["|cffffff78/Navi reset <zone>|r - Resets all waypoints in zone"])
end

local zlist = {}
for cidx,c in ipairs{GetMapContinents()} do
    for zidx,z in ipairs{GetMapZones(cidx)} do
        zlist[z:lower():gsub("[%L]", "")] = {cidx, zidx, z}
    end
end

function IlarosNavi:GetClosestWaypoint()
    local c,z,x,y = Astrolabe:GetCurrentPlayerPosition()
    local zone = IlarosNavi:GetMapFile(c, z)
    local closest_uid = nil
    local closest_dist = nil
    if waypoints[zone] then
        for uid in pairs(waypoints[zone]) do
            local dist,x,y = IlarosNavi:GetDistanceToWaypoint(uid)
            if (dist and closest_dist == nil) or (dist and dist < closest_dist) then
                closest_dist = dist
                closest_uid = uid
            end
        end
    end
    if closest_dist then
        return closest_uid
    end
end

function IlarosNavi:SetClosestWaypoint()
    local uid = self:GetClosestWaypoint()
    if uid then
        local data = waypoints[uid]
        IlarosNavi:SetCrazyArrow(uid, IlarosNavi.profile.arrow.arrival, data.title)
    end
end

SLASH_IlarosNavi_CLOSEST_WAYPOINT1 = "/NaviN"
SLASH_IlarosNavi_CLOSEST_WAYPOINT2 = "/NaviNah"
SlashCmdList["IlarosNavi_CLOSEST_WAYPOINT"] = function(msg)
    IlarosNavi:SetClosestWaypoint()
end

SLASH_IlarosNavi_WAYBACK1 = "/NaviH"
SLASH_IlarosNavi_WAYBACK2 = "/NaviHier"
SlashCmdList["IlarosNavi_WAYBACK"] = function(msg)
    local backc,backz,backx,backy = Astrolabe:GetCurrentPlayerPosition()
    IlarosNavi:AddZWaypoint(backc, backz, backx*100, backy*100, L["Wayback"])
end

SLASH_IlarosNavi_VERSION1 = "/NaviV"
SLASH_IlarosNavi_VERSION2 = "/NaviVersion"
SlashCmdList["IlarosNavi_VERSION"] = function(msg)
    NaviText_Echo(NaviText_FName)
    NaviText_Echo(string.format(NaviText_FVer,IlarosNavi.version))
end

SLASH_IlarosNavi_WAY1 = "/NaviZ"
SLASH_IlarosNavi_WAY2 = "/NaviZiel"
SlashCmdList["IlarosNavi_WAY"] = function(msg)
    local tokens = {}
    for token in msg:gmatch("%S+") do table.insert(tokens, token) end

    -- Lower the first token
    if tokens[1] then
        tokens[1] = tokens[1]:lower()
    end

    if tokens[1] == "reset" then
        if tokens[2] == "all" then
            if IlarosNavi.db.profile.general.confirmremoveall then
                StaticPopup_Show("IlarosNavi_REMOVE_ALL_CONFIRM")
            else
                StaticPopupDialogs["IlarosNavi_REMOVE_ALL_CONFIRM"].OnAccept()
                return
            end

        elseif tokens[2] then
            -- Reset the named zone
            local zone = table.concat(tokens, " ", 2)

            -- Find a fuzzy match for the zone
            local matches = {}
            zone = zone:lower():gsub("[%L]", "")

            for z,entry in pairs(zlist) do
                if z:match(zone) then
                    table.insert(matches, entry)
                end
            end

            if #matches > 5 then
                local msg = string.format(L["Found %d possible matches for zone %s.  Please be more specific"], #matches, tokens[2])
                NaviText_Echo(msg)
                return
            elseif #matches > 1 then
                local poss = {}
                for k,v in pairs(matches) do
                    table.insert(poss, v[3])
                end
                table.sort(poss)

                NaviText_Echo(string.format(L["Found multiple matches for zone '%s'.  Did you mean: %s"], tokens[2], table.concat(poss, ", ")))
                return
            end

            local c,z,name = unpack(matches[1])
            local zone = IlarosNavi:GetMapFile(c, z)
            if waypoints[zone] then
                for uid in pairs(waypoints[zone]) do
                    IlarosNavi:RemoveWaypoint(uid)
                end
                NaviText_Echo(NaviText_WPUnsetZone:format(name))
            else
                NaviText_Echo(NaviText_WPUnsetNo:format(name))
            end
        end
    elseif tokens[1] and not tonumber(tokens[1]) then
        -- Find the first numeric token
        local zoneEnd = 1
        for idx,token in ipairs(tokens) do
            if tonumber(token) then
                zoneEnd = idx - 1
                break
            end
        end

        -- This is a waypoint set, with a zone before the coords
        local zone = table.concat(tokens, " ", 1, zoneEnd)
        local x,y,desc = select(zoneEnd + 1, unpack(tokens))

        if desc then desc = table.concat(tokens, " ", zoneEnd + 3) end

        -- Find a fuzzy match for the zone
        local matches = {}
        zone = zone:lower():gsub("[%L]", "")

        for z,entry in pairs(zlist) do
            if z:match(zone) then
                table.insert(matches, entry)
            end
        end

        if #matches ~= 1 then
                local msg = string.format(L["Found %d possible matches for zone %s.  Please be more specific"], #matches, tokens[1])
                NaviText_Echo(msg)
            return
        end

        local c,z,name = unpack(matches[1])

        if not x or not tonumber(x) then
            return usage()
        elseif not y or not tonumber(y) then
            return usage()
        end

        x = tonumber(x)
        y = tonumber(y)
        IlarosNavi:AddZWaypoint(c, z, x, y, desc)
    elseif tonumber(tokens[1]) then
        -- A vanilla set command
        local x,y,desc = unpack(tokens)
        if not x or not tonumber(x) then
            return usage()
        elseif not y or not tonumber(y) then
            return usage()
        end
        if desc then
            desc = table.concat(tokens, " ", 3)
        end

        x = tonumber(x)
        y = tonumber(y)
        IlarosNavi:AddWaypoint(x, y, desc)
    else
        return Ilaros_Usage()
    end
end
