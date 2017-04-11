----------------------------------------------------------------------------
-- IlarosNavi
-- Modul zur Koordinatenanzeige
----------------------------------------------------------------------------

-- Signalfarben
-- grün: an
local R_ON = 0
local G_ON = 1
local B_ON = 0
-- rot: aus
local R_OFF = 1
local G_OFF = 0
local B_OFF = 0
-- gelb: Information
local R_INFO = 1
local G_INFO = 1
local B_INFO = 0

function round(float)
    return floor(float+0.5)
end

function shwcrdcursor(num)
    if (NaviPlay["show decimals"] == true and IlarosNavi.db.profile.mapcoords.cursoraccuracy == 1) then
        return format("%1.1f", round(num * 1000) / 10)
    else
        if (NaviPlay["show decimals"] == true and IlarosNavi.db.profile.mapcoords.cursoraccuracy == 2) then
            return format("%1.2f", round(num * 10000) / 100)
        else
            return round(num * 100)
        end
    end
end

function shwcrdplayer(num)
    if (NaviPlay["show decimals"] == true and IlarosNavi.db.profile.mapcoords.playeraccuracy == 1) then
        return format("%1.1f", round(num * 1000) / 10)
    else
        if (NaviPlay["show decimals"] == true and IlarosNavi.db.profile.mapcoords.playeraccuracy == 2) then
            return format("%1.2f", round(num * 10000) / 100)
        else
            return round(num * 100)
        end
    end
end

function shwcrd(num)
    if (NaviPlay["show decimals"] == true) then
        return format("%1.1f", round(num * 1000) / 10)
    else
        return round(num * 100)
    end
end

function NaviText_OnLoad()
    SlashCmdList["MAPCOORDS"] = NaviText_SlashCommand
    SLASH_MAPCOORDS1 = "/Navi"

    if (not NaviPlay) then
        NaviPlay = {}
        NaviPlay["worldmap cursor"]=true
        NaviPlay["worldmap player"]=true
        NaviPlay["portrait player"]=true
        NaviPlay["portrait party1"]=true
        NaviPlay["portrait party2"]=true
        NaviPlay["portrait party3"]=true
        NaviPlay["portrait party4"]=true
        NaviPlay["show decimals"]=false
    end

    MapCoordsBlizzardOptions()
end

function NaviText_Echo(msg,r,g,b)
    if (not r) then r = 1 end
    if (not g) then g = 1 end
    if (not b) then b = 1 end

    DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b)
end

function NaviText_SlashCommand(msg)
    -- Weltkarte
    if (string.lower(msg) == "a") then
        if (NaviPlay["worldmap cursor"] == true and NaviPlay["worldmap player"] == true) then
            NaviPlay["worldmap cursor"]=false
            NaviPlay["worldmap player"]=false
            NaviText_Echo(NaviText_HWorld,R_OFF,G_OFF,B_OFF)
        else
            NaviPlay["worldmap cursor"]=true
            NaviPlay["worldmap player"]=true
            NaviText_Echo(NaviText_SWorld,R_ON,G_ON,B_ON)
        end
    elseif (string.lower(msg) == "c") then
        if (NaviPlay["worldmap cursor"] == true) then
            NaviPlay["worldmap cursor"]=false
            NaviText_Echo(NaviText_HCursor,R_OFF,G_OFF,B_OFF)
        else
            NaviPlay["worldmap cursor"]=true
            NaviText_Echo(NaviText_SCursor,R_ON,G_ON,B_ON)
        end
    elseif (string.lower(msg) == "s") then
        if (NaviPlay["worldmap player"] == true) then
            NaviPlay["worldmap player"]=false
            NaviText_Echo(NaviText_HWPlayer,R_OFF,G_OFF,B_OFF)
        else
            NaviPlay["worldmap player"]=true
            NaviText_Echo(NaviText_SWPlayer,R_ON,G_ON,B_ON)
        end
    -- Portraits
    elseif (string.lower(msg) == "p") then
        if (NaviPlay["portrait player"] == true and
        NaviPlay["portrait party1"] == true and
        NaviPlay["portrait party2"] == true and
        NaviPlay["portrait party3"] == true and
        NaviPlay["portrait party4"] == true) then
            NaviPlay["portrait player"]=false
            NaviPlay["portrait party1"]=false
            NaviPlay["portrait party2"]=false
            NaviPlay["portrait party3"]=false
            NaviPlay["portrait party4"]=false
            NaviText_Echo(NaviText_HPortrait,R_OFF,G_OFF,B_OFF)
        else
            NaviPlay["portrait player"]=true
            NaviPlay["portrait party1"]=true
            NaviPlay["portrait party2"]=true
            NaviPlay["portrait party3"]=true
            NaviPlay["portrait party4"]=true
            NaviText_Echo(NaviText_SPortrait,R_ON,G_ON,B_ON)
        end
    elseif (string.lower(msg) == "p0") then
        if (NaviPlay["portrait player"] == true) then
            NaviPlay["portrait player"]=false
            NaviText_Echo(NaviText_HPlayer,R_OFF,G_OFF,B_OFF)
        else
            NaviPlay["portrait player"]=true
            NaviText_Echo(NaviText_SPlayer,R_ON,G_ON,B_ON)
        end
    elseif (string.lower(msg) == "g") then
        if (NaviPlay["portrait party1"] == true and
        NaviPlay["portrait party2"] == true and
        NaviPlay["portrait party3"] == true and
        NaviPlay["portrait party4"] == true) then
            NaviPlay["portrait party1"]=false
            NaviPlay["portrait party2"]=false
            NaviPlay["portrait party3"]=false
            NaviPlay["portrait party4"]=false
            NaviText_Echo(NaviText_HAParty,R_OFF,G_OFF,B_OFF)
        else
            NaviPlay["portrait party1"]=true
            NaviPlay["portrait party2"]=true
            NaviPlay["portrait party3"]=true
            NaviPlay["portrait party4"]=true
            NaviText_Echo(NaviText_SAParty,R_ON,G_ON,B_ON)
        end
    elseif (string.lower(msg) == "p1") then
        if (NaviPlay["portrait party1"] == true) then
            NaviPlay["portrait party1"]=false
            NaviText_Echo(NaviText_HParty1,R_OFF,G_OFF,B_OFF)
        else
            NaviPlay["portrait party1"]=true
            NaviText_Echo(NaviText_SParty1,R_ON,G_ON,B_ON)
        end
    elseif (string.lower(msg) == "p2") then
        if (NaviPlay["portrait party2"] == true) then
            NaviPlay["portrait party2"]=false
            NaviText_Echo(NaviText_HParty2,R_OFF,G_OFF,B_OFF)
        else
            NaviPlay["portrait party2"]=true
            NaviText_Echo(NaviText_SParty2,R_ON,G_ON,B_ON)
        end
    elseif (string.lower(msg) == "p3") then
        if (NaviPlay["portrait party3"] == true) then
            NaviPlay["portrait party3"]=false
            NaviText_Echo(NaviText_HParty3,R_OFF,G_OFF,B_OFF)
        else
            NaviPlay["portrait party3"]=true
            NaviText_Echo(NaviText_SParty3,R_ON,G_ON,B_ON)
        end
    elseif (string.lower(msg) == "p4") then
        if (NaviPlay["portrait party4"] == true) then
            NaviPlay["portrait party4"]=false
            NaviText_Echo(NaviText_HParty4,R_OFF,G_OFF,B_OFF)
        else
            NaviPlay["portrait party4"]=true
            NaviText_Echo(NaviText_SParty4,R_ON,G_ON,B_ON)
        end
    -- alles andere
    elseif (string.lower(msg) == "o") then
        SlashCmdList["IlarosNavi"](msg)
    elseif (string.lower(msg) == "v") then
        SlashCmdList["IlarosNavi_VERSION"](msg)
    elseif (string.lower(msg) == "h") then
        SlashCmdList["IlarosNavi_WAYBACK"](msg)
    elseif (string.lower(msg) == "n") then
        SlashCmdList["IlarosNavi_CLOSEST_WAYPOINT"](msg)
    else
        SlashCmdList["IlarosNavi_WAY"](msg)
    end
    if MapCoordsOptions:IsVisible() then
        MapCoordsSetCheckButtonState()
    end
end

function Ilaros_Usage()
        NaviText_Echo(NaviText_SLASH1)
        NaviText_Echo(NaviText_VER)
        NaviText_Echo(NaviText_OPT)
        NaviText_Echo(NaviText_SLASH2)
        if (NaviPlay["worldmap cursor"] == true and NaviPlay["worldmap player"] == true) then
            NaviText_Echo(NaviText_WMON,R_ON,G_ON,B_ON)
        else NaviText_Echo(NaviText_WMOFF,R_OFF,G_OFF,B_OFF) end
        if (NaviPlay["worldmap cursor"] == true) then
            NaviText_Echo(NaviText_WMCON,R_ON,G_ON,B_ON)
        else NaviText_Echo(NaviText_WMCOFF,R_OFF,G_OFF,B_OFF) end
        if (NaviPlay["worldmap player"] == true) then
            NaviText_Echo(NaviText_WMPON,R_ON,G_ON,B_ON)
        else NaviText_Echo(NaviText_WMPOFF,R_OFF,G_OFF,B_OFF) end
        NaviText_Echo(NaviText_SLASH3)
        if (NaviPlay["portrait player"] == true and NaviPlay["portrait party1"] == true and NaviPlay["portrait party2"] == true and NaviPlay["portrait party3"] == true and NaviPlay["portrait party4"] == true) then
            NaviText_Echo(NaviText_APON,R_ON,G_ON,B_ON)
        else NaviText_Echo(NaviText_APOFF,R_OFF,G_OFF,B_OFF) end
        if (NaviPlay["portrait party1"] == true and NaviPlay["portrait party2"] == true and NaviPlay["portrait party3"] == true and NaviPlay["portrait party4"] == true) then
            NaviText_Echo(NaviText_APMON,R_ON,G_ON,B_ON)
        else NaviText_Echo(NaviText_APMOFF,R_OFF,G_OFF,B_OFF) end
        if (NaviPlay["portrait player"] == true) then
            NaviText_Echo(NaviText_YPON,R_ON,G_ON,B_ON)
        else NaviText_Echo(NaviText_YPOFF,R_OFF,G_OFF,B_OFF) end
        if (NaviPlay["portrait party1"] == true) then
            NaviText_Echo(NaviText_P1ON,R_ON,G_ON,B_ON)
        else NaviText_Echo(NaviText_P1OFF,R_OFF,G_OFF,B_OFF) end
        if (NaviPlay["portrait party2"] == true) then
            NaviText_Echo(NaviText_P2ON,R_ON,G_ON,B_ON)
        else NaviText_Echo(NaviText_P2OFF,R_OFF,G_OFF,B_OFF) end
        if (NaviPlay["portrait party3"] == true) then
            NaviText_Echo(NaviText_P3ON,R_ON,G_ON,B_ON)
        else NaviText_Echo(NaviText_P3OFF,R_OFF,G_OFF,B_OFF) end
        if (NaviPlay["portrait party4"] == true) then
            NaviText_Echo(NaviText_P4ON,R_ON,G_ON,B_ON)
        else NaviText_Echo(NaviText_P4OFF,R_OFF,G_OFF,B_OFF) end
        NaviText_Echo(NaviText_SLASH6)
        NaviText_Echo(NaviText_WAY1)
        NaviText_Echo(NaviText_WAY2)
        NaviText_Echo(NaviText_WAY3)
        NaviText_Echo(NaviText_WAY4)
        NaviText_Echo(NaviText_WAY5)
end

function MapCoordsSetCheckButtonState()
    MapCoordsCheckButton1:SetChecked(NaviPlay["worldmap player"])
    MapCoordsCheckButton2:SetChecked(NaviPlay["worldmap cursor"])
    MapCoordsCheckButton3:SetChecked(NaviPlay["portrait player"])
    MapCoordsCheckButton4:SetChecked(NaviPlay["portrait party1"])
    MapCoordsCheckButton5:SetChecked(NaviPlay["portrait party2"])
    MapCoordsCheckButton6:SetChecked(NaviPlay["portrait party3"])
    MapCoordsCheckButton7:SetChecked(NaviPlay["portrait party4"])
    MapCoordsCheckButton8:SetChecked(NaviPlay["show decimals"])
end

function MapCoordsPlayer_OnUpdate()
    if (NaviPlay["portrait player"] == true) then
        local posX, posY = GetPlayerMapPosition("player")
        if ( posX == 0 and posY == 0 ) then
            MapCoordsPlayerPortraitCoords:SetText("n/a")
        else
            MapCoordsPlayerPortraitCoords:SetText(shwcrd(posX).." / "..shwcrd(posY))
        end
    else
        MapCoordsPlayerPortraitCoords:SetText("")
    end
    if (NaviPlay["portrait party1"] == true and GetNumPartyMembers() >= 1) then
        local posX, posY = GetPlayerMapPosition("party1")
        if ( posX == 0 and posY == 0 ) then
            MapCoordsParty1PortraitCoords:SetText("n/a")
        else
            MapCoordsParty1PortraitCoords:SetText(shwcrd(posX).." / "..shwcrd(posY))
        end
    else
        MapCoordsParty1PortraitCoords:SetText("")
    end
    if (NaviPlay["portrait party2"] == true and GetNumPartyMembers() >= 2) then
        local posX, posY = GetPlayerMapPosition("party2")
        if ( posX == 0 and posY == 0 ) then
            MapCoordsParty2PortraitCoords:SetText("n/a")
        else
            MapCoordsParty2PortraitCoords:SetText(shwcrd(posX).." / "..shwcrd(posY))
        end
    else
        MapCoordsParty2PortraitCoords:SetText("")
    end
    if (NaviPlay["portrait party3"] == true and GetNumPartyMembers() >= 3) then
        local posX, posY = GetPlayerMapPosition("party3")
        if ( posX == 0 and posY == 0 ) then
            MapCoordsParty3PortraitCoords:SetText("n/a")
        else
            MapCoordsParty3PortraitCoords:SetText(shwcrd(posX).." / "..shwcrd(posY))
        end
    else
        MapCoordsParty3PortraitCoords:SetText("")
    end
    if (NaviPlay["portrait party4"] == true and GetNumPartyMembers() >= 4) then
        local posX, posY = GetPlayerMapPosition("party4")
        if ( posX == 0 and posY == 0 ) then
            MapCoordsParty4PortraitCoords:SetText("n/a")
        else
            MapCoordsParty4PortraitCoords:SetText(shwcrd(posX).." / "..shwcrd(posY))
        end
    else
        MapCoordsParty4PortraitCoords:SetText("")
    end
end

function MapCoordsWorldMap_OnUpdate()
    local output = ""
    if (NaviPlay["worldmap cursor"] == true) then
        local scale = WorldMapDetailFrame:GetEffectiveScale()
        local width = WorldMapDetailFrame:GetWidth()
        local height = WorldMapDetailFrame:GetHeight()
        local centerX, centerY = WorldMapDetailFrame:GetCenter()
        local x, y = GetCursorPosition()
        -- Tweak coords so they are accurate
        local adjustedX = (x / scale - (centerX - (width/2))) / width
        local adjustedY = (centerY + (height/2) - y / scale) / height

        -- Write output
        if (adjustedX >= 0  and adjustedY >= 0 and adjustedX <=1 and adjustedY <=1) then
            output = NaviText_SLASH4..shwcrdcursor(adjustedX).." / "..shwcrdcursor(adjustedY)
        end
    end
    if (NaviPlay["worldmap cursor"] == true and NaviPlay["worldmap player"]) then
        if (output ~= "") then
            output = output.." --- "
        end
    end
    if (NaviPlay["worldmap player"] == true) then
        local px, py = GetPlayerMapPosition("player")
        if ( px == 0 and py == 0 ) then
            output = output..NaviText_SLASH5.."n/a"
        else
            output = output..NaviText_SLASH5..shwcrdplayer(px).." / "..shwcrdplayer(py)
        end
    end
    MapCoordsWorldMap:SetText(output)
end

function MapCoordsBlizzardOptions()
-- Hauptrahmen für Informationstext erzeugen
local MapCoordsOptions = CreateFrame("FRAME", "MapCoordsOptions")
MapCoordsOptions:SetScript("OnShow", function(self) MapCoordsSetCheckButtonState() end)
MapCoordsOptions.name = "IlarosNavi"
InterfaceOptions_AddCategory(MapCoordsOptions)

local MapCoordsOptionsHeader = MapCoordsOptions:CreateFontString(nil, "ARTWORK")
MapCoordsOptionsHeader:SetFontObject(GameFontNormalLarge)
MapCoordsOptionsHeader:SetJustifyH("LEFT")
MapCoordsOptionsHeader:SetJustifyV("TOP")
MapCoordsOptionsHeader:ClearAllPoints()
MapCoordsOptionsHeader:SetPoint("TOPLEFT", 16, -16)
MapCoordsOptionsHeader:SetText("IlarosNavi")

local MapCoordsOptionsWM = MapCoordsOptions:CreateFontString(nil, "ARTWORK")
MapCoordsOptionsWM:SetFontObject(GameFontWhite)
MapCoordsOptionsWM:SetJustifyH("LEFT")
MapCoordsOptionsWM:SetJustifyV("TOP")
MapCoordsOptionsWM:ClearAllPoints()
MapCoordsOptionsWM:SetPoint("TOPLEFT", MapCoordsOptionsHeader, "BOTTOMLEFT", 0, -6)
MapCoordsOptionsWM:SetText(NaviText_WMOP)

local MapCoordsCheckButton1 = CreateFrame("CheckButton", "MapCoordsCheckButton1", MapCoordsOptions, "OptionsCheckButtonTemplate")
MapCoordsCheckButton1:SetPoint("TOPLEFT", MapCoordsOptionsWM, "BOTTOMLEFT", 2, -4)
MapCoordsCheckButton1:SetScript("OnClick", function(self) NaviText_SlashCommand("wp") end)
MapCoordsCheckButton1Text:SetText(NaviText_WMOP1)

local MapCoordsCheckButton2 = CreateFrame("CheckButton", "MapCoordsCheckButton2", MapCoordsOptions, "OptionsCheckButtonTemplate")
MapCoordsCheckButton2:SetPoint("TOPLEFT", MapCoordsCheckButton1, "BOTTOMLEFT", 0, -4)
MapCoordsCheckButton2:SetScript("OnClick", function(self) NaviText_SlashCommand("wc") end)
MapCoordsCheckButton2Text:SetText(NaviText_WMOP2)

local MapCoordsOptionsPortrait = MapCoordsOptions:CreateFontString(nil, "ARTWORK")
MapCoordsOptionsPortrait:SetFontObject(GameFontWhite)
MapCoordsOptionsPortrait:SetJustifyH("LEFT")
MapCoordsOptionsPortrait:SetJustifyV("TOP")
MapCoordsOptionsPortrait:ClearAllPoints()
MapCoordsOptionsPortrait:SetPoint("TOPLEFT", MapCoordsCheckButton2, "BOTTOMLEFT", -2, -4)
MapCoordsOptionsPortrait:SetText(NaviText_PTOP)

local MapCoordsCheckButton3 = CreateFrame("CheckButton", "MapCoordsCheckButton3", MapCoordsOptions, "OptionsCheckButtonTemplate")
MapCoordsCheckButton3:SetPoint("TOPLEFT", MapCoordsOptionsPortrait, "BOTTOMLEFT", 2, -4)
MapCoordsCheckButton3:SetScript("OnClick", function(self) NaviText_SlashCommand("player") end)
MapCoordsCheckButton3Text:SetText(NaviText_PTP)

local MapCoordsCheckButton4 = CreateFrame("CheckButton", "MapCoordsCheckButton4", MapCoordsOptions, "OptionsCheckButtonTemplate")
MapCoordsCheckButton4:SetPoint("TOPLEFT", MapCoordsCheckButton3, "BOTTOMLEFT", 0, -4)
MapCoordsCheckButton4:SetScript("OnClick", function(self) NaviText_SlashCommand("p1") end)
MapCoordsCheckButton4Text:SetText(NaviText_PTG1)

local MapCoordsCheckButton5 = CreateFrame("CheckButton", "MapCoordsCheckButton5", MapCoordsOptions, "OptionsCheckButtonTemplate")
MapCoordsCheckButton5:SetPoint("TOPLEFT", MapCoordsCheckButton4, "BOTTOMLEFT", 0, -4)
MapCoordsCheckButton5:SetScript("OnClick", function(self) NaviText_SlashCommand("p2") end)
MapCoordsCheckButton5Text:SetText(NaviText_PTG2)

local MapCoordsCheckButton6 = CreateFrame("CheckButton", "MapCoordsCheckButton6", MapCoordsOptions, "OptionsCheckButtonTemplate")
MapCoordsCheckButton6:SetPoint("TOPLEFT", MapCoordsCheckButton5, "BOTTOMLEFT", 0, -4)
MapCoordsCheckButton6:SetScript("OnClick", function(self) NaviText_SlashCommand("p3") end)
MapCoordsCheckButton6Text:SetText(NaviText_PTG3)

local MapCoordsCheckButton7 = CreateFrame("CheckButton", "MapCoordsCheckButton7", MapCoordsOptions, "OptionsCheckButtonTemplate")
MapCoordsCheckButton7:SetPoint("TOPLEFT", MapCoordsCheckButton6, "BOTTOMLEFT", 0, -4)
MapCoordsCheckButton7:SetScript("OnClick", function(self) NaviText_SlashCommand("p4") end)
MapCoordsCheckButton7Text:SetText(NaviText_PTG4)

local MapCoordsOptionsMisc = MapCoordsOptions:CreateFontString(nil, "ARTWORK")
MapCoordsOptionsMisc:SetFontObject(GameFontWhite)
MapCoordsOptionsMisc:SetJustifyH("LEFT")
MapCoordsOptionsMisc:SetJustifyV("TOP")
MapCoordsOptionsMisc:ClearAllPoints()
MapCoordsOptionsMisc:SetPoint("TOPLEFT", MapCoordsCheckButton7, "BOTTOMLEFT", -2, -4)
MapCoordsOptionsMisc:SetText(NaviText_MOP)

local MapCoordsCheckButton8 = CreateFrame("CheckButton", "MapCoordsCheckButton8", MapCoordsOptions, "OptionsCheckButtonTemplate")
MapCoordsCheckButton8:SetPoint("TOPLEFT", MapCoordsOptionsMisc, "BOTTOMLEFT", 2, -4)
MapCoordsCheckButton8:SetScript("OnClick", function(self) if NaviPlay["show decimals"] == true then NaviPlay["show decimals"] = false else NaviPlay["show decimals"] = true end end)
MapCoordsCheckButton8Text:SetText(NaviText_SDCD)

local MapCoordsOptionsHint = MapCoordsOptions:CreateFontString(nil, "ARTWORK")
MapCoordsOptionsHint:SetFontObject(GameFontWhite)
MapCoordsOptionsHint:SetJustifyH("LEFT")
MapCoordsOptionsHint:SetJustifyV("TOP")
MapCoordsOptionsHint:ClearAllPoints()
MapCoordsOptionsHint:SetPoint("TOPLEFT", MapCoordsCheckButton8, "BOTTOMLEFT", -2, -4)
MapCoordsOptionsHint:SetText(NaviText_HINT)

end