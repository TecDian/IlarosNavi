-- benutzbare Farbcodes:
-- |cff00ff00 = grün/green
-- |cffff0000 = rot/red
-- |cff00ffff = hellblau/light blue
-- |cff0055FF = blau/blue

-- Signalfarben
-- grün: an
local R_ON = 0
local G_ON = 1
local B_ON = 0
-- rot: aus
local R_OFF = 1
local G_OFF = 0
local B_OFF = 0
-- gelb: Version
local R_ABOUT = 1
local G_ABOUT = 1
local B_ABOUT = 0

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

function MapCoords_OnLoad()
	SlashCmdList["MAPCOORDS"] = MapCoords_SlashCommand
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

function MapCoords_Echo(msg,r,g,b)
	if (not r) then r = 1 end
	if (not g) then g = 1 end
	if (not b) then b = 1 end
	
	DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b)
end

function MapCoords_SlashCommand(msg)
	-- Weltkarte
	if (string.lower(msg) == "a") then
		if (NaviPlay["worldmap cursor"] == true and NaviPlay["worldmap player"] == true) then
			NaviPlay["worldmap cursor"]=false
			NaviPlay["worldmap player"]=false
			MapCoords_Echo(MAPCOORDS_HWorld)
		else
			NaviPlay["worldmap cursor"]=true
			NaviPlay["worldmap player"]=true
			MapCoords_Echo(MAPCOORDS_SWorld)
		end
	elseif (string.lower(msg) == "c") then
		if (NaviPlay["worldmap cursor"] == true) then
			NaviPlay["worldmap cursor"]=false
			MapCoords_Echo(MAPCOORDS_HCursor)
		else
			NaviPlay["worldmap cursor"]=true
			MapCoords_Echo(MAPCOORDS_SCursor)
		end
	elseif (string.lower(msg) == "s") then
		if (NaviPlay["worldmap player"] == true) then
			NaviPlay["worldmap player"]=false
			MapCoords_Echo(MAPCOORDS_HWPlayer)
		else
			NaviPlay["worldmap player"]=true
			MapCoords_Echo(MAPCOORDS_SWPlayer)
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
			MapCoords_Echo(MAPCOORDS_HPortrait)
		else
			NaviPlay["portrait player"]=true
			NaviPlay["portrait party1"]=true
			NaviPlay["portrait party2"]=true
			NaviPlay["portrait party3"]=true
			NaviPlay["portrait party4"]=true
			MapCoords_Echo(MAPCOORDS_SPortrait)
		end
	elseif (string.lower(msg) == "p0") then
		if (NaviPlay["portrait player"] == true) then
			NaviPlay["portrait player"]=false
			MapCoords_Echo(MAPCOORDS_HPlayer)
		else
			NaviPlay["portrait player"]=true
			MapCoords_Echo(MAPCOORDS_SPlayer)
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
			MapCoords_Echo(MAPCOORDS_HAParty)
		else
			NaviPlay["portrait party1"]=true
			NaviPlay["portrait party2"]=true
			NaviPlay["portrait party3"]=true
			NaviPlay["portrait party4"]=true
			MapCoords_Echo(MAPCOORDS_SAParty)
		end
	elseif (string.lower(msg) == "p1") then
		if (NaviPlay["portrait party1"] == true) then
			NaviPlay["portrait party1"]=false
			MapCoords_Echo(MAPCOORDS_HParty1)
		else
			NaviPlay["portrait party1"]=true
			MapCoords_Echo(MAPCOORDS_SParty1)
		end
	elseif (string.lower(msg) == "p2") then
		if (NaviPlay["portrait party2"] == true) then
			NaviPlay["portrait party2"]=false
			MapCoords_Echo(MAPCOORDS_HParty2)
		else
			NaviPlay["portrait party2"]=true
			MapCoords_Echo(MAPCOORDS_SParty2)
		end
	elseif (string.lower(msg) == "p3") then
		if (NaviPlay["portrait party3"] == true) then
			NaviPlay["portrait party3"]=false
			MapCoords_Echo(MAPCOORDS_HParty3)
		else
			NaviPlay["portrait party3"]=true
			MapCoords_Echo(MAPCOORDS_SParty3)
		end
	elseif (string.lower(msg) == "p4") then
		if (NaviPlay["portrait party4"] == true) then
			NaviPlay["portrait party4"]=false
			MapCoords_Echo(MAPCOORDS_HParty4)
		else
			NaviPlay["portrait party4"]=true
			MapCoords_Echo(MAPCOORDS_SParty4)
		end
    -- alles andere
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
		MapCoords_Echo(MAPCOORDS_SLASH1)
        MapCoords_Echo(MAPCOORDS_ABOUT,R_ABOUT,G_ABOUT,B_ABOUT)
		MapCoords_Echo(MAPCOORDS_SLASH2)
		if (NaviPlay["worldmap cursor"] == true and NaviPlay["worldmap player"] == true) then 
            MapCoords_Echo(MAPCOORDS_WMON,R_ON,G_ON,B_ON)
		else MapCoords_Echo(MAPCOORDS_WMOFF,R_OFF,G_OFF,B_OFF) end
		if (NaviPlay["worldmap cursor"] == true) then 
            MapCoords_Echo(MAPCOORDS_WMCON,R_ON,G_ON,B_ON)
		else MapCoords_Echo(MAPCOORDS_WMCOFF,R_OFF,G_OFF,B_OFF) end
		if (NaviPlay["worldmap player"] == true) then 
            MapCoords_Echo(MAPCOORDS_WMPON,R_ON,G_ON,B_ON)
		else MapCoords_Echo(MAPCOORDS_WMPOFF,R_OFF,G_OFF,B_OFF) end
		MapCoords_Echo(MAPCOORDS_SLASH3)
		if (NaviPlay["portrait player"] == true and NaviPlay["portrait party1"] == true and NaviPlay["portrait party2"] == true and NaviPlay["portrait party3"] == true and NaviPlay["portrait party4"] == true) then 
            MapCoords_Echo(MAPCOORDS_APON,R_ON,G_ON,B_ON)
		else MapCoords_Echo(MAPCOORDS_APOFF,R_OFF,G_OFF,B_OFF) end
		if (NaviPlay["portrait party1"] == true and NaviPlay["portrait party2"] == true and NaviPlay["portrait party3"] == true and NaviPlay["portrait party4"] == true) then 
            MapCoords_Echo(MAPCOORDS_APMON,R_ON,G_ON,B_ON)
		else MapCoords_Echo(MAPCOORDS_APMOFF,R_OFF,G_OFF,B_OFF) end
		if (NaviPlay["portrait player"] == true) then 
            MapCoords_Echo(MAPCOORDS_YPON,R_ON,G_ON,B_ON)
		else MapCoords_Echo(MAPCOORDS_YPOFF,R_OFF,G_OFF,B_OFF) end
		if (NaviPlay["portrait party1"] == true) then 
            MapCoords_Echo(MAPCOORDS_P1ON,R_ON,G_ON,B_ON)
		else MapCoords_Echo(MAPCOORDS_P1OFF,R_OFF,G_OFF,B_OFF) end
		if (NaviPlay["portrait party2"] == true) then 
            MapCoords_Echo(MAPCOORDS_P2ON,R_ON,G_ON,B_ON)
		else MapCoords_Echo(MAPCOORDS_P2OFF,R_OFF,G_OFF,B_OFF) end
		if (NaviPlay["portrait party3"] == true) then 
            MapCoords_Echo(MAPCOORDS_P3ON,R_ON,G_ON,B_ON)
		else MapCoords_Echo(MAPCOORDS_P3OFF,R_OFF,G_OFF,B_OFF) end
		if (NaviPlay["portrait party4"] == true) then 
            MapCoords_Echo(MAPCOORDS_P4ON,R_ON,G_ON,B_ON)
		else MapCoords_Echo(MAPCOORDS_P4OFF,R_OFF,G_OFF,B_OFF) end
		MapCoords_Echo(MAPCOORDS_SLASH6)
        MapCoords_Echo(MAPCOORDS_WAY1)
        MapCoords_Echo(MAPCOORDS_WAY2)
        MapCoords_Echo(MAPCOORDS_WAY3)
        MapCoords_Echo(MAPCOORDS_WAY4)
        MapCoords_Echo(MAPCOORDS_WAY5)
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
            output = MAPCOORDS_SLASH4..shwcrdcursor(adjustedX).." / "..shwcrdcursor(adjustedY)
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
            output = output..MAPCOORDS_SLASH5.."n/a"
		else
            output = output..MAPCOORDS_SLASH5..shwcrdplayer(px).." / "..shwcrdplayer(py)
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
MapCoordsOptionsWM:SetText(MAPCOORDS_WMOP)

local MapCoordsCheckButton1 = CreateFrame("CheckButton", "MapCoordsCheckButton1", MapCoordsOptions, "OptionsCheckButtonTemplate")
MapCoordsCheckButton1:SetPoint("TOPLEFT", MapCoordsOptionsWM, "BOTTOMLEFT", 2, -4)
MapCoordsCheckButton1:SetScript("OnClick", function(self) MapCoords_SlashCommand("wp") end)
MapCoordsCheckButton1Text:SetText(MAPCOORDS_WMOP1)

local MapCoordsCheckButton2 = CreateFrame("CheckButton", "MapCoordsCheckButton2", MapCoordsOptions, "OptionsCheckButtonTemplate")
MapCoordsCheckButton2:SetPoint("TOPLEFT", MapCoordsCheckButton1, "BOTTOMLEFT", 0, -4)
MapCoordsCheckButton2:SetScript("OnClick", function(self) MapCoords_SlashCommand("wc") end)
MapCoordsCheckButton2Text:SetText(MAPCOORDS_WMOP2)

local MapCoordsOptionsPortrait = MapCoordsOptions:CreateFontString(nil, "ARTWORK")
MapCoordsOptionsPortrait:SetFontObject(GameFontWhite)
MapCoordsOptionsPortrait:SetJustifyH("LEFT") 
MapCoordsOptionsPortrait:SetJustifyV("TOP")
MapCoordsOptionsPortrait:ClearAllPoints()
MapCoordsOptionsPortrait:SetPoint("TOPLEFT", MapCoordsCheckButton2, "BOTTOMLEFT", -2, -4)
MapCoordsOptionsPortrait:SetText(MAPCOORDS_PTOP)

local MapCoordsCheckButton3 = CreateFrame("CheckButton", "MapCoordsCheckButton3", MapCoordsOptions, "OptionsCheckButtonTemplate")
MapCoordsCheckButton3:SetPoint("TOPLEFT", MapCoordsOptionsPortrait, "BOTTOMLEFT", 2, -4)
MapCoordsCheckButton3:SetScript("OnClick", function(self) MapCoords_SlashCommand("player") end)
MapCoordsCheckButton3Text:SetText(MAPCOORDS_PTP)

local MapCoordsCheckButton4 = CreateFrame("CheckButton", "MapCoordsCheckButton4", MapCoordsOptions, "OptionsCheckButtonTemplate")
MapCoordsCheckButton4:SetPoint("TOPLEFT", MapCoordsCheckButton3, "BOTTOMLEFT", 0, -4)
MapCoordsCheckButton4:SetScript("OnClick", function(self) MapCoords_SlashCommand("p1") end)
MapCoordsCheckButton4Text:SetText(MAPCOORDS_PTG1)

local MapCoordsCheckButton5 = CreateFrame("CheckButton", "MapCoordsCheckButton5", MapCoordsOptions, "OptionsCheckButtonTemplate")
MapCoordsCheckButton5:SetPoint("TOPLEFT", MapCoordsCheckButton4, "BOTTOMLEFT", 0, -4)
MapCoordsCheckButton5:SetScript("OnClick", function(self) MapCoords_SlashCommand("p2") end)
MapCoordsCheckButton5Text:SetText(MAPCOORDS_PTG2)

local MapCoordsCheckButton6 = CreateFrame("CheckButton", "MapCoordsCheckButton6", MapCoordsOptions, "OptionsCheckButtonTemplate")
MapCoordsCheckButton6:SetPoint("TOPLEFT", MapCoordsCheckButton5, "BOTTOMLEFT", 0, -4)
MapCoordsCheckButton6:SetScript("OnClick", function(self) MapCoords_SlashCommand("p3") end)
MapCoordsCheckButton6Text:SetText(MAPCOORDS_PTG3)

local MapCoordsCheckButton7 = CreateFrame("CheckButton", "MapCoordsCheckButton7", MapCoordsOptions, "OptionsCheckButtonTemplate")
MapCoordsCheckButton7:SetPoint("TOPLEFT", MapCoordsCheckButton6, "BOTTOMLEFT", 0, -4)
MapCoordsCheckButton7:SetScript("OnClick", function(self) MapCoords_SlashCommand("p4") end)
MapCoordsCheckButton7Text:SetText(MAPCOORDS_PTG4)

local MapCoordsOptionsMisc = MapCoordsOptions:CreateFontString(nil, "ARTWORK")
MapCoordsOptionsMisc:SetFontObject(GameFontWhite)
MapCoordsOptionsMisc:SetJustifyH("LEFT") 
MapCoordsOptionsMisc:SetJustifyV("TOP")
MapCoordsOptionsMisc:ClearAllPoints()
MapCoordsOptionsMisc:SetPoint("TOPLEFT", MapCoordsCheckButton7, "BOTTOMLEFT", -2, -4)
MapCoordsOptionsMisc:SetText(MAPCOORDS_MOP)

local MapCoordsCheckButton8 = CreateFrame("CheckButton", "MapCoordsCheckButton8", MapCoordsOptions, "OptionsCheckButtonTemplate")
MapCoordsCheckButton8:SetPoint("TOPLEFT", MapCoordsOptionsMisc, "BOTTOMLEFT", 2, -4)
MapCoordsCheckButton8:SetScript("OnClick", function(self) if NaviPlay["show decimals"] == true then NaviPlay["show decimals"] = false else NaviPlay["show decimals"] = true end end)
MapCoordsCheckButton8Text:SetText(MAPCOORDS_SDCD)

local MapCoordsOptionsHint = MapCoordsOptions:CreateFontString(nil, "ARTWORK")
MapCoordsOptionsHint:SetFontObject(GameFontWhite)
MapCoordsOptionsHint:SetJustifyH("LEFT") 
MapCoordsOptionsHint:SetJustifyV("TOP")
MapCoordsOptionsHint:ClearAllPoints()
MapCoordsOptionsHint:SetPoint("TOPLEFT", MapCoordsCheckButton8, "BOTTOMLEFT", -2, -4)
MapCoordsOptionsHint:SetText(MAPCOORDS_HINT)

end