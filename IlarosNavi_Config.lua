----------------------------------------------------------------------------
-- IlarosNavi
-- Modul für das Optionsfenster
----------------------------------------------------------------------------

-- Einfache Lokalisierungstabelle für Texte
local L = IlarosNaviLocals

local function createconfig()
	local options = {}

	options.type = "group"
	options.name = "IlarosNavi"

	local function get(info)
		local ns,opt = string.split(".", info.arg)
		local val = IlarosNavi.db.profile[ns][opt]
		--IlarosNavi:Print("get", ns, opt, val)
		if type(val) == "table" then
			return unpack(val)
		else
			return val
		end
	end

	local function set(info, arg1, arg2, arg3, arg4)
		local ns,opt = string.split(".", info.arg)
		--IlarosNavi:Print("set", ns, opt, arg1, arg2, arg3, arg4)
		if arg2 then
			local entry = IlarosNavi.db.profile[ns][opt]
			entry[1] = arg1
			entry[2] = arg2
			entry[3] = arg3
			entry[4] = arg4
		else
			IlarosNavi.db.profile[ns][opt] = arg1
		end

		if ns == "block" then
			IlarosNavi:ShowHideCoordBlock()
		elseif ns == "mapcoords" then
			IlarosNavi:ShowHideWorldCoords()
		elseif ns == "arrow" then
			IlarosNavi:ShowHideCrazyArrow()
        elseif ns == "poi" then
            IlarosNavi:EnableDisablePOIIntegration()
		elseif opt == "otherzone" then
			IlarosNavi:ReloadWaypoints()
		elseif info.arg == "minimap.enable" or info.arg == "worldmap.enable" then
			IlarosNavi:ReloadWaypoints()
		elseif info.arg == "feeds.coords_throttle" then
			IlarosNavi:UpdateCoordFeedThrottle()
		elseif info.arg == "feeds.arrow_throttle" then
			IlarosNavi:UpdateArrowFeedThrottle()
		end
	end

	options.args = {}

	options.args.coordblock = {
		type = "group",
		order = 2,
		name = L["Coordinate Block"],
		desc = L["Options that alter the coordinate block"],
		get = get,
		set = set,
		args = {
			desc = {
				order = 1,
				type = "description",
				name = L["IlarosNavi provides you with a floating coordinate display that can be used to determine your current position.  These options can be used to enable or disable this display, or customize the block's display."],
			},      
			enable = {
				order = 2,
				type = "toggle",
				name = L["Enable coordinate block"],
				desc = L["Enables a floating block that displays your current position in the current zone"],
				width = "double",
				arg = "block.enable",
			},
			lock = {
				order = 3,
				type = "toggle",
				name = L["Lock coordinate block"],
				desc = L["Locks the coordinate block so it can't be accidentally dragged to another location"],
				width = "double",
				arg = "block.lock",
			},
			accuracy = {
				order = 4,
				type = "range",
				name = L["Coordinate Accuracy"],
				desc = L["Coordinates can be displayed as simple XX, YY coordinate, or as more precise XX.XX, YY.YY.  This setting allows you to control that precision"],
				min = 0, max = 2, step = 1,
				arg = "block.accuracy",
			},
			display = {
				order = 4,
				type = "group",
				inline = true,
				name = L["Display Settings"],
				args = {
					help = {
						type = "description",
						name = L["The display of the coordinate block can be customized by changing the options below."],
						order = 1,
					},
					bordercolor = {
						type = "color",
						name = L["Border color"],
						arg = "block.bordercolor",
						hasAlpha = true,
					},
					bgcolor = {
						type = "color",
						name = L["Background color"],
						arg = "block.bgcolor",
						hasAlpha = true,
					},
					height = {
						type = "range",
						name = L["Block height"],
						arg = "block.height",
						min = 5, max = 50, step = 1,
					},
					width = {
						type = "range",
						name = L["Block width"],
						arg = "block.width",
						min = 50, max = 250, step = 5,
					},
					fontsize = {
						type = "range",
						name = L["Font size"],
						arg = "block.fontsize",
						min = 1, max = 24, step = 1,
					},
					reset_position = {
						type = "execute",
						name = L["Reset Position"],
						desc = L["Resets the position of the coordinate block if its been dragged off screen"],
						func = function()
							if IlarosNaviBlock then
								IlarosNaviBlock:ClearAllPoints()
								IlarosNaviBlock:SetPoint("TOP", Minimap, "BOTTOM", -20, -10)
							end
						end,
					},
				},
			},
		},
	} -- End coordinate block settings

	options.args.crazytaxi = {
		type = "group",
		order = 3, 
		name = L["Waypoint Arrow"],
		get = get,
		set = set,
		args = {
			help = {
				order = 1,
				type = "description",
				name = L["IlarosNavi provides an arrow that can be placed anywhere on the screen.  Similar to the arrow in \"Crazy Taxi\" it will point you towards your next waypoint"],
			},   
			enable = {
				order = 2,
				type = "toggle",
				name = L["Enable floating waypoint arrow"],
				width = "double",
				arg = "arrow.enable",
			},
			autoqueue = {
				order = 3,
				type = "toggle",
				width = "double",
				name = L["Automatically set waypoint arrow"],
				desc = L["When a new waypoint is added, IlarosNavi can automatically set the new waypoint as the \"Crazy Arrow\" waypoint."],
				arg = "arrow.autoqueue",
			},
			lock = {
				order = 4,
				type = "toggle",
				name = L["Lock waypoint arrow"],
				desc = L["Locks the waypoint arrow, so it can't be moved accidentally"],
				arg = "arrow.lock",
			},
			arrival = {
				order = 5,
				type = "toggle",
				name = L["Show estimated time to arrival"],
				desc = L["Shows an estimate of how long it will take you to reach the waypoint at your current speed"],
				width = "double",
				arg = "arrow.showtta",
			},
			rightclick = {
				order = 6,
				type = "toggle",
				name = L["Enable the right-click contextual menu"],
				desc = L["Enables a menu when right-clicking on the waypoint arrow allowing you to clear or remove waypoints"],
				width = "double",
				arg = "arrow.menu",
			},
			disableclick = {
				order = 7,
				type = "toggle",
				name = L["Disable all mouse input"],
				desc = L["Disables the crazy taxi arrow for mouse input, allowing all clicks to pass through"],
				width = "double",
				arg = "arrow.noclick",
			},
			setclosest = {
				order = 8,
				type = "toggle",
				name = L["Automatically set to next closest waypoint"],
				desc = L["When the current waypoint is cleared (either by the user or automatically) and this option is set, IlarosNavi will automatically set the closest waypoint in the current zone as active waypoint."],
				width = "double",
				arg = "arrow.setclosest",
			},
			heredistance = {
				order = 9,
				type = "range",
				name = L["\"Arrival Distance\""],
				desc = L["This setting will control the distance at which the waypoint arrow switches to a downwards arrow, indicating you have arrived at your destination"],
				min = 0, max = 150, step = 5,
				arg = "arrow.arrival",
			},
            enablePing = {
                order = 9.5,
                type = "toggle",
                name = L["Play a sound when arriving at a waypoint"],
                desc = L["When you 'arrive' at a waypoint (this distance is controlled by the 'Arrival Distance' setting in this group) a sound can be played to indicate this.  You can enable or disable this sound using this setting."],
                width = "double",
                arg = "arrow.enablePing",
            },
			display = {
				type = "group",
				name = L["Arrow display"],
				order = 10,
				inline = true,
				args = {
					help = {
						type = "description",
						order = 1,
						name = L["These options let you customize the size and opacity of the waypoint arrow, making it larger or partially transparent, as well as limiting the size of the title display."],
					},
					scale = {
						type = "range",
						order = 2,
						name = L["Scale"],
						desc = L["This setting allows you to change the scale of the waypoint arrow, making it larger or smaller"],
						min = 0, max = 3, step = 0.05,
						arg = "arrow.scale",
					},
					alpha = {
						type = "range",
						order = 3,
						name = L["Alpha"],
						desc = L["This setting allows you to change the opacity of the waypoint arrow, making it transparent or opaque"],
						min = 0, max = 1.0, step = 0.05,
						arg = "arrow.alpha",
					},
					title_width = {
						type = "range",
						order = 4,
						name = L["Title Width"],
						desc = L["This setting allows you to specify the maximum width of the title text.  Any titles that are longer than this width (in game pixels) will be wrapped to the next line."],
						min = 0, max = 500, step = 1,
						arg = "arrow.title_width",
					},
					title_height = {
						type = "range",
						order = 5,
						name = L["Title Height"],
						desc = L["This setting allows you to specify the maximum height of the title text.  Any titles that are longer than this height (in game pixels) will be truncated."],
						min = 0, max = 300, step = 1,
						arg = "arrow.title_height",
					},
					title_scale = {
						type = "range",
						order = 6,
						name = L["Title Scale"],
						desc = L["This setting allows you to specify the scale of the title text."],
						min = 0, max = 3, step = 0.05,
						arg = "arrow.title_scale",
					},
					title_alpha = {
						type = "range",
						order = 7,
						name = L["Title Alpha"],
						desc = L["This setting allows you to change the opacity of the title text, making it transparent or opaque"],
						min = 0, max = 1.0, step = 0.05,
						arg = "arrow.title_alpha",
					},
					reset_position = {
						order = 8,
						type = "execute",
						name = L["Reset Position"],
						desc = L["Resets the position of the waypoint arrow if its been dragged off screen"],
						func = function()
							IlarosNaviCrazyArrow:ClearAllPoints()
							IlarosNaviCrazyArrow:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
						end,
					},
				}
			},
			color = {
				type = "group",
				name = L["Arrow colors"],
				order = 10,
				inline = true,
				args = {
					help = {
						order = 1,
						type = "description",
						name = L["The floating waypoint arrow can change color depending on whether or nor you are facing your destination.  By default it will display green when you are facing it directly, and red when you are facing away from it.  These colors can be changed in this section.  Setting these options to the same color will cause the arrow to not change color at all"],
					},
					colorstart = {
						order = 2,
						type = "color",
						name = L["Good color"],
						desc = L["The color to be displayed when you are moving in the direction of the active waypoint"],
						arg = "arrow.goodcolor",
						hasAlpha = false,
					},
					colormiddle = {
						order = 3,
						type = "color",
						name = L["Middle color"],
						desc = L["The color to be displayed when you are halfway between the direction of the active waypoint and the completely wrong direction"],
						arg = "arrow.middlecolor",
						hasAlpha = false,
					},
					colorend = {
						order = 4,
						type = "color",
						name = L["Bad color"],
						desc = L["The color to be displayed when you are moving in the opposite direction of the active waypoint"],
						arg = "arrow.badcolor",
						hasAlpha = false,
					},
				},
			},
		},   
	} -- End crazy taxi options

	options.args.minimap = {
		type = "group",
		order = 4,
		name = L["Minimap"],
		get = get,
		set = set,
		args = {
			help = {
				order = 1,
				type = "description",
				name = L["IlarosNavi can display multiple waypoint arrows on the minimap.  These options control the display of these waypoints"],
			},
			enable = {
				order = 2,
				type = "toggle",
				name = L["Enable minimap waypoints"],
				width = "double",
				arg = "minimap.enable",
			},
			otherzone = {
				type = "toggle",
				name = L["Display waypoints from other zones"],
				desc = L["IlarosNavi can hide waypoints in other zones, this setting toggles that functionality"],   
				width = "double",
				arg = "minimap.otherzone",
				disabled = true,
			},
			tooltip = {
				type = "toggle",
				name = L["Enable mouseover tooltips"],
				desc = L["IlarosNavi can display a tooltip containing information abouto waypoints, when they are moused over.  This setting toggles that functionality"],
				width = "double",
				arg = "minimap.tooltip",
			},
			rightclick = {
				type = "toggle",
				name = L["Enable the right-click contextual menu"],
				desc = L["Enables a menu when right-clicking on a waypoint allowing you to clear or remove waypoints"],
				width = "double",
				arg = "minimap.menu",
			},
		},
	} -- End minimap options

	options.args.worldmap = {
		type = "group",
		order = 5,
		name = L["World Map"],
		get = get,
		set = set,
		args = {
			help = {
				order = 1,
				type = "description",
				name = L["IlarosNavi can display multiple waypoints on the world map.  These options control the display of these waypoints"],
			},
			enable = {
				order = 2,
				type = "toggle",
				name = L["Enable world map waypoints"],
				width = "double",
				arg = "worldmap.enable",
			},
			otherzone = {
				order = 3,
				type = "toggle",
				name = L["Display waypoints from other zones"],
				desc = L["IlarosNavi can hide waypoints in other zones, this setting toggles that functionality"],   
				width = "double",
				arg = "worldmap.otherzone",
				disabled = true,
			},
			tooltip = {
				order = 4,
				type = "toggle",
				name = L["Enable mouseover tooltips"],
				desc = L["IlarosNavi can display a tooltip containing information abouto waypoints, when they are moused over.  This setting toggles that functionality"],
				width = "double",
				arg = "worldmap.tooltip",
			},
			createclick = {
				order = 5,
				type = "toggle",
				name = L["Allow control-right clicking on map to create new waypoint"],
				width = "double",
				arg = "worldmap.clickcreate",
			},
			rightclick = {
				type = "toggle",
				order = 6,
				name = L["Enable the right-click contextual menu"],
				desc = L["Enables a menu when right-clicking on a waypoint allowing you to clear or remove waypoints"],
				width = "double",
				arg = "worldmap.menu",
			},
			modifier = {
				type = "select",
				order = 7,
				name = L["Create note modifier"],
				desc = L["This setting changes the modifier used by IlarosNavi when right-clicking on the world map to create a waypoint"],
				values = {
					["A"] = "Alt",
					["C"] = "Ctrl",
					["S"] = "Shift",
					["AC"] = "Alt-Ctrl",
					["AS"] = "Alt-Shift",
					["CS"] = "Ctrl-Shift",
					["ACS"] = "Alt-Ctrl-Shift",
				},
				arg = "worldmap.create_modifier",
			},
			player = {
				order = 8,
				type = "group",
				inline = true,
				name = L["Player Coordinates"],
				args = {
--					enableplayer = {
--						order = 1,
--						type = "toggle",
--						name = L["Enable showing player coordinates"],
--						width = "double",
--						arg = "mapcoords.playerenable",
--					},
					playeraccuracy = {
						order = 4,
						type = "range",
						name = L["Player coordinate accuracy"],
						desc = L["Coordinates can be displayed as simple XX, YY coordinate, or as more precise XX.XX, YY.YY.  This setting allows you to control that precision"],
						min = 0, max = 2, step = 1,
						arg = "mapcoords.playeraccuracy",
					},
				},
			},
			cursor = {
				order = 9,
				type = "group",
				inline = true,
				name = L["Cursor Coordinates"],
				args = {
--					enablecursor = {
--						order = 3,
--						type = "toggle",
--						name = L["Enable showing cursor coordinates"],
--						width = "double",
--						arg = "mapcoords.cursorenable",
--					},
					cursoraccuracy = {
						order = 5,
						type = "range",
						name = L["Cursor coordinate accuracy"],
						desc = L["Coordinates can be displayed as simple XX, YY coordinate, or as more precise XX.XX, YY.YY.  This setting allows you to control that precision"],
						min = 0, max = 2, step = 1,
						arg = "mapcoords.cursoraccuracy",
					},
				},
			},
		},
	} -- End world map options

	-- LDB Data Feeds
	options.args.feeds = {
		type = "group",
		order = 8,
		name = L["Data Feed Options"],
		get = get,
		set = set,
		args = {
			help = {
				order = 1,
				type = "description",
				name = L["IlarosNavi is capable of providing data sources via LibDataBroker, which allows them to be displayed in any LDB compatible display.  These options enable or disable the individual feeds, but will only take effect after a reboot."],
			},
			coords = {
				type = "toggle",
				order = 2,
				name = L["Provide a LDB data source for coordinates"],
				width = "double",
				arg = "feeds.coords",
			},
			coords_throttle = {
				type = "range",
				order = 3,
				name = L["Coordinate feed throttle"],
				desc = L["Controls the frequency of updates for the coordinate LDB feed."],
				width = "double",
				min = 0, max = 2.0, step = 0.05,
				arg = "feeds.coords_throttle",
			},
			accuracy = {
				order = 4,
				type = "range",
				name = L["Coordinate feed accuracy"],
				desc = L["Coordinates can be displayed as simple XX, YY coordinate, or as more precise XX.XX, YY.YY.  This setting allows you to control that precision"],
				min = 0, max = 2, step = 1,
				arg = "feeds.coords_accuracy",
			},
			arrow = {
				type = "toggle",
				order = 5,
				name = L["Provide a LDB data source for the crazy-arrow"],
				width = "double",
				arg = "feeds.arrow",
			},
			arrow_throttle = {
				type = "range",
				order = 6,
				name = L["Crazy Arrow feed throttle"],
				desc = L["Controls the frequency of updates for the crazy arrow LDB feed."],
				width = "double",
				min = 0, max = 2.0, step = 0.05,
				arg = "feeds.arrow_throttle",
			},
		},
	}

	options.args.general = {
		type = "group",
		order = 1,
		name = NaviText_GOPT,
		get = get,
		set = set,
		args = {
			--[[
			comm = {
				type = "toggle",
				order = 1,
				name = L["Accept waypoints from guild and party members"],
				width = "double",
				arg = "comm.enable",
			},
			promptcomm = {
				type = "toggle",
				order = 2,
				name = L["Prompt before accepting sent waypoints"],
				width = "double",
				arg = "comm.prompt",
			},
			--]]
			announce = {
				type = "toggle",
				order = 1,
				name = L["Announce new waypoints when they are added"],
				desc = L["IlarosNavi can announce new waypoints to the default chat frame when they are added"],
				width = "double",
				arg = "general.announce",
			},
			confirmremove = {
				type = "toggle",
				order = 2,
				name = L["Ask for confirmation on \"Remove All\""],
				desc = L["This option will toggle whether or not you are asked to confirm removing all waypoints.  If enabled, a dialog box will appear, requiring you to confirm removing the waypoints"],
				width = "double",
				arg = "general.confirmremoveall",
			},
			persistence = {
				type = "toggle",
				order = 3,
				name = L["Save new waypoints until I remove them"],
				desc = L["This option will not remove any waypoints that are currently set to persist, but only effects new waypoints that get set"],
				width = "double",
				arg = "persistence.savewaypoints",
			},
			cleardistance = {
				type = "range",
				order = 4,
				name = L["Clear waypoint distance"],
				desc = L["Waypoints can be automatically cleared when you reach them.  This slider allows you to customize the distance in yards that signals your \"arrival\" at the waypoint.  A setting of 0 turns off the auto-clearing feature\n\nChanging this setting only takes effect after reloading your interface."],  
				min = 0, max = 150, step = 1,
				arg = "persistence.cleardistance",
			},
			corpse_arrow = {
				type = "toggle",
				order = 6,
				name = L["Automatically set a waypoint when I die"],
				desc = L["IlarosNavi can automatically set a waypoint when you die, guiding you back to your corpse"],
				width = "double",
				arg = "general.corpse_arrow",
			},
		},
	}

    options.args.poi = {
		type = "group",
		order = 6,
		name = L["Quest Objectives"],
		desc = L["Options that alter quest objective integration"],
		get = get,
		set = set,
		args = {
			desc = {
				order = 1,
				type = "description",
				name = L["IlarosNavi can be configured to set waypoints for the quest objectives that are shown in the watch frame and on the world map.  These options can be used to configure these options."],
			},      
			enable = {
				order = 2,
				type = "toggle",
				name = L["Enable quest objective click integration"],
				desc = L["Enables the setting of waypoints when modified-clicking on quest objectives"],
				width = "double",
				arg = "poi.enable",
			},
            modifier = {
				type = "select",
				order = 3,
				name = L["set waypoint modifier"],
				desc = L["This setting changes the modifier used by IlarosNavi when right-clicking on a quest objective POI to create a waypoint"],
				values = {
					["A"] = "Alt",
					["C"] = "Ctrl",
					["S"] = "Shift",
					["AC"] = "Alt-Ctrl",
					["AS"] = "Alt-Shift",
					["CS"] = "Ctrl-Shift",
					["ACS"] = "Alt-Ctrl-Shift",
				},
				arg = "poi.modifier",
			},
            enableClosest = {
				order = 4,
				type = "toggle",
				name = L["Enable automatic quest objective waypoints"],
				desc = L["Enables the automatic setting of quest objective waypoints based on which objective is closest to your current location.  This setting WILL override the setting of manual waypoints."],
				width = "double",
				arg = "poi.setClosest",
			},
		},
	} -- End POI Integration settings

	options.args.profile = {
		type = "group",
		order = 7,
		name = L["Profile Options"],
		args = {
			desc = {
				order = 1,
				type = "description",
				name = L["IlarosNavi's saved variables are organized so you can have shared options across all your characters, while having different sets of waypoints for each.  These options sections allow you to change the saved variable configurations so you can set up per-character options, or even share waypoints between characters"],
			},
			options = LibStub("AceDBOptions-3.0"):GetOptionsTable(IlarosNavi.db),
			waypoints = LibStub("AceDBOptions-3.0"):GetOptionsTable(IlarosNavi.waydb)
		}
	}

	options.args.profile.args.options.name = L["Options profile"]
	options.args.profile.args.options.desc = L["Saved profile for IlarosNavi options"]
	options.args.profile.args.options.order = 2

	options.args.profile.args.waypoints.name = L["Waypoints profile"]
	options.args.profile.args.waypoints.desc = L["Save profile for IlarosNavi waypoints"]
	options.args.profile.args.waypoints.order = 3

	return options
end

local config = LibStub("AceConfig-3.0")
local dialog = LibStub("AceConfigDialog-3.0")
local registered = false;

local options

local function createBlizzOptions()
	options = createconfig()

--	config:RegisterOptionsTable("NaviPlay-Bliz", {
--		name = L["IlarosNavi"],
--		type = "group",
--		args = {
--			help = {
--				type = "description",
--				name = L["IlarosNavi is a simple navigation assistant"],
--			},
--		},
--	})
--	dialog:SetDefaultSize("IlarosNavi-Bliz", 600, 400)
--	dialog:AddToBlizOptions("IlarosNavi-Bliz", "IlarosNavi")

	-- General Options
	config:RegisterOptionsTable("IlarosNavi-General", options.args.general)
	local blizzPanel = dialog:AddToBlizOptions("IlarosNavi-General", options.args.general.name, "IlarosNavi")

	-- Coordinate Block Options
	config:RegisterOptionsTable("IlarosNavi-CoordBlock", options.args.coordblock)
	dialog:AddToBlizOptions("IlarosNavi-CoordBlock", options.args.coordblock.name, "IlarosNavi")

	-- Crazy Taxi Options
	config:RegisterOptionsTable("IlarosNavi-CrazyTaxi", options.args.crazytaxi)
	dialog:AddToBlizOptions("IlarosNavi-CrazyTaxi", options.args.crazytaxi.name, "IlarosNavi")

	-- Minimap Options
	config:RegisterOptionsTable("IlarosNavi-Minimap", options.args.minimap)
	dialog:AddToBlizOptions("IlarosNavi-Minimap", options.args.minimap.name, "IlarosNavi")

	-- World Map Options
	config:RegisterOptionsTable("IlarosNavi-Worldmap", options.args.worldmap)
	dialog:AddToBlizOptions("IlarosNavi-Worldmap", options.args.worldmap.name, "IlarosNavi")

	-- World Map Options
	config:RegisterOptionsTable("IlarosNavi-Feeds", options.args.feeds)
	dialog:AddToBlizOptions("IlarosNavi-Feeds", options.args.feeds.name, "IlarosNavi")

    -- POI Options
	config:RegisterOptionsTable("IlarosNavi-POI", options.args.poi)
	dialog:AddToBlizOptions("IlarosNavi-POI", options.args.poi.name, "IlarosNavi")

	-- Profile Options
	local p_options = options.args.profile.args.options
	local w_options = options.args.profile.args.waypoints
	config:RegisterOptionsTable("IlarosNavi-Profiles-Waypoints", w_options)
	config:RegisterOptionsTable("IlarosNavi-Profiles-Options", p_options)
	dialog:AddToBlizOptions("IlarosNavi-Profiles-Waypoints", w_options.name, "IlarosNavi")
	dialog:AddToBlizOptions("IlarosNavi-Profiles-Options", p_options.name, "IlarosNavi")
	return blizzPanel
end

SLASH_IlarosNavi1 = "/NaviK"
SLASH_IlarosNavi2 = "/NaviKonfiguration"
local blizzPanel
SlashCmdList["IlarosNavi"] = function(msg)
	if not registered then
		blizzPanel = createBlizzOptions()
		registered = true
	end

	InterfaceOptionsFrame_OpenToCategory("IlarosNavi")
end

local hijackFrame = CreateFrame("Frame", nil, InterfaceOptionsFrame)
hijackFrame:SetScript("OnShow", function(self)
	if not registered then
		blizzPanel = createBlizzOptions()
		registered = true
	end

	self:SetScript("OnShow", nil)
end)
