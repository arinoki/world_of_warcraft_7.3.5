---------------------------------------------------------
-- Module declaration
local HandyNotes = LibStub("AceAddon-3.0"):GetAddon("HandyNotes")
local HN = HandyNotes:NewModule("HandyNotes", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("HandyNotes", false)

local WoW80 = select(4, GetBuildInfo()) >= 80000

local HBD = WoW80 and LibStub("HereBeDragons-2.0") or LibStub("HereBeDragons-1.0")
local PIN_DRAG_SCALE = 1.2

---------------------------------------------------------
-- Our db upvalue and db defaults
local db
local dbdata
local defaults = {
	global = {
		["*"] = {},  -- ["mapFile"] = {[coord] = {note data}, [coord] = {note data}}
	},
	profile = {
		icon_scale         = 1.0,
		icon_alpha         = 1.0,
	},
}

---------------------------------------------------------
-- Localize some globals
local next = next
local wipe = wipe
local GameTooltip = GameTooltip
local WorldMapTooltip = WorldMapTooltip


---------------------------------------------------------
-- Constants
-- An addon can replace this table or add to it directly, but keep in mind
-- notes are currently stored with the index number of the chosen icon.
HN.icons = {
	[1] = UnitPopupButtons.RAID_TARGET_1, -- Star
	[2] = UnitPopupButtons.RAID_TARGET_2, -- Circle
	[3] = UnitPopupButtons.RAID_TARGET_3, -- Diamond
	[4] = UnitPopupButtons.RAID_TARGET_4, -- Triangle
	[5] = UnitPopupButtons.RAID_TARGET_5, -- Moon
	[6] = UnitPopupButtons.RAID_TARGET_6, -- Square
	[7] = UnitPopupButtons.RAID_TARGET_7, -- Cross
	[8] = UnitPopupButtons.RAID_TARGET_8, -- Skull
	[9] = {text = MINIMAP_TRACKING_AUCTIONEER, icon = "Interface\\Minimap\\Tracking\\Auctioneer"},
	[10] = {text = MINIMAP_TRACKING_BANKER, icon = "Interface\\Minimap\\Tracking\\Banker"},
	[11] = {text = MINIMAP_TRACKING_BATTLEMASTER, icon = "Interface\\Minimap\\Tracking\\BattleMaster"},
	[12] = {text = MINIMAP_TRACKING_FLIGHTMASTER, icon = "Interface\\Minimap\\Tracking\\FlightMaster"},
	[13] = {text = MINIMAP_TRACKING_INNKEEPER, icon = "Interface\\Minimap\\Tracking\\Innkeeper"},
	[14] = {text = MINIMAP_TRACKING_MAILBOX, icon = "Interface\\Minimap\\Tracking\\Mailbox"},
	[15] = {text = MINIMAP_TRACKING_REPAIR, icon = "Interface\\Minimap\\Tracking\\Repair"},
	[16] = {text = MINIMAP_TRACKING_STABLEMASTER, icon = "Interface\\Minimap\\Tracking\\StableMaster"},
	[17] = {text = MINIMAP_TRACKING_TRAINER_CLASS, icon = "Interface\\Minimap\\Tracking\\Class"},
	[18] = {text = MINIMAP_TRACKING_TRAINER_PROFESSION, icon = "Interface\\Minimap\\Tracking\\Profession"},
	[19] = {text = MINIMAP_TRACKING_TRIVIAL_QUESTS, icon = "Interface\\Minimap\\Tracking\\TrivialQuests"},
	[20] = {text = MINIMAP_TRACKING_VENDOR_AMMO, icon = "Interface\\Minimap\\Tracking\\Ammunition"},
	[21] = {text = MINIMAP_TRACKING_VENDOR_FOOD, icon = "Interface\\Minimap\\Tracking\\Food"},
	[22] = {text = MINIMAP_TRACKING_VENDOR_POISON, icon = "Interface\\Minimap\\Tracking\\Poisons"},
	[23] = {text = MINIMAP_TRACKING_VENDOR_REAGENT, icon = "Interface\\Minimap\\Tracking\\Reagents"},
	[24] = {text = FACTION_ALLIANCE, icon = "Interface\\TargetingFrame\\UI-PVP-Alliance",
		tCoordLeft = 0.05, tCoordRight = 0.65, tCoordTop = 0, tCoordBottom = 0.6},
	[25] = {text = FACTION_HORDE, icon = "Interface\\TargetingFrame\\UI-PVP-Horde",
		tCoordLeft = 0.05, tCoordRight = 0.65, tCoordTop = 0, tCoordBottom = 0.6},
	[26] = {text = FACTION_STANDING_LABEL4, icon = "Interface\\TargetingFrame\\UI-PVP-FFA",
		tCoordLeft = 0.05, tCoordRight = 0.65, tCoordTop = 0, tCoordBottom = 0.6},
	[27] = {text = ARENA, icon = "Interface\\PVPFrame\\PVP-ArenaPoints-Icon"},
	[28] = {text = L["Portal"], icon = "Interface\\Icons\\Spell_Arcane_PortalDalaran"},
}


---------------------------------------------------------
-- Plugin Handlers to HandyNotes

local HNHandler = {}

function HNHandler:OnEnter(mapFile, coord)
	local tooltip = self:GetParent() == WorldMapButton and WorldMapTooltip or GameTooltip
	if ( self:GetCenter() > UIParent:GetCenter() ) then -- compare X coordinate
		tooltip:SetOwner(self, "ANCHOR_LEFT")
	else
		tooltip:SetOwner(self, "ANCHOR_RIGHT")
	end
	local title = dbdata[mapFile][coord].title
	local desc = dbdata[mapFile][coord].desc
	if title == "" and desc == "" then title = L["(No Title)"] end
	if title == "" and desc ~= "" then title = desc  desc = nil end
	tooltip:SetText(title)
	tooltip:AddLine(desc, nil, nil, nil, true)
	tooltip:Show()
end

function HNHandler:OnLeave(mapFile, coord)
	if self:GetParent() == WorldMapButton then
		WorldMapTooltip:Hide()
	else
		GameTooltip:Hide()
	end
end

local function deletePin(button, mapFile, coord)
	local HNEditFrame = HN.HNEditFrame
	if HNEditFrame.coord == coord and HNEditFrame.mapFile == mapFile then
		HNEditFrame:Hide()
	end
	dbdata[mapFile][coord] = nil
	HN:SendMessage("HandyNotes_NotifyUpdate", "HandyNotes")
end

local function editPin(button, mapFile, coord)
	local HNEditFrame = HN.HNEditFrame
	HNEditFrame.x, HNEditFrame.y = HandyNotes:getXY(coord)
	HNEditFrame.coord = coord
	HNEditFrame.mapFile = mapFile
	HNEditFrame.level = dbdata[mapFile][coord].level
	HN:FillDungeonLevelData()
	HNEditFrame:Hide() -- Hide first to trigger the OnShow handler
	HNEditFrame:Show()
end

local function addTomTomWaypoint(button, mapFile, coord)
	if TomTom then
		local mapId = HandyNotes:GetMapFiletoMapID(mapFile)
		local x, y = HandyNotes:getXY(coord)
		TomTom:AddMFWaypoint(mapId, nil, x, y, {
			title = dbdata[mapFile][coord].title,
			persistent = nil,
			minimap = true,
			world = true
		})
	end
end

do
	local isMoving = false
	local movingPinScale = nil
	local info = {}
	local clickedMapFile = nil
	local clickedCoord = nil
	local function generateMenu(button, level)
		if (not level) then return end
		for k in pairs(info) do info[k] = nil end
		if (level == 1) then
			-- Create the title of the menu
			info.isTitle      = 1
			info.text         = L["HandyNotes"]
			info.notCheckable = 1
			local t = HN.icons[dbdata[clickedMapFile][clickedCoord].icon]
			info.icon         = t.icon
			info.tCoordLeft   = t.tCoordLeft
			info.tCoordRight  = t.tCoordRight
			info.tCoordTop    = t.tCoordTop
			info.tCoordBottom = t.tCoordBottom
			UIDropDownMenu_AddButton(info, level)

			-- Edit menu item
			info.disabled     = nil
			info.isTitle      = nil
			info.notCheckable = nil
			info.icon         = nil
			info.tCoordLeft   = nil
			info.tCoordRight  = nil
			info.tCoordTop    = nil
			info.tCoordBottom = nil
			info.text = L["Edit Handy Note"]
			info.func = editPin
			info.arg1 = clickedMapFile
			info.arg2 = clickedCoord
			UIDropDownMenu_AddButton(info, level)

			-- Delete menu item
			info.text = L["Delete Handy Note"]
			info.func = deletePin
			info.arg1 = clickedMapFile
			info.arg2 = clickedCoord
			UIDropDownMenu_AddButton(info, level)

			if TomTom then
				info.text = L["Add this location to TomTom waypoints"]
				info.func = addTomTomWaypoint
				info.arg1 = clickedMapFile
				info.arg2 = clickedCoord
				UIDropDownMenu_AddButton(info, level)
			end

			-- Close menu item
			info.text         = CLOSE
			info.func         = function() CloseDropDownMenus() end
			info.arg1         = nil
			info.arg2         = nil
			info.notCheckable = 1
			UIDropDownMenu_AddButton(info, level)

			-- Add the dragging hint
			info.isTitle      = 1
			info.func         = nil
			info.text         = L["|cFF00FF00Hint: |cffeda55fCtrl+Shift+LeftDrag|cFF00FF00 to move a note"]
			UIDropDownMenu_AddButton(info, level)
		end
	end
	local HandyNotes_HandyNotesDropdownMenu = CreateFrame("Frame", "HandyNotes_HandyNotesDropdownMenu")
	HandyNotes_HandyNotesDropdownMenu.displayMode = "MENU"
	HandyNotes_HandyNotesDropdownMenu.initialize = generateMenu

	function HNHandler:OnClick(button, down, mapFile, coord)
		if button == "RightButton" and not down then
			clickedMapFile = mapFile
			clickedCoord = coord
			ToggleDropDownMenu(1, nil, HandyNotes_HandyNotesDropdownMenu, self, 0, 0)
		elseif button == "LeftButton" and down and IsControlKeyDown() and IsShiftKeyDown() then
			-- Only move if we're viewing the same map as the icon's map
			if not WoW80 then
				if mapFile == HandyNotes:WhereAmI() or mapFile == "World" or mapFile == "Cosmic" then
					isMoving = true
					local x, y = self:GetCenter()
					local s = WorldMapButton:GetEffectiveScale() / UIParent:GetEffectiveScale()
					self:ClearAllPoints()
					self:SetParent(UIParent)
					self:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x * s, y * s)
					self:SetFrameStrata("TOOLTIP")
					self:StartMoving()
				end
			else
				if mapFile == WorldMapFrame:GetMapID() then
					isMoving = true
					movingPinScale = self:GetScale()
					local x, y = self:GetCenter()
					local s = self:GetEffectiveScale() / UIParent:GetEffectiveScale()
					self:ClearAllPoints()
					self:SetParent(UIParent)
					self:SetScale(PIN_DRAG_SCALE)
					self:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x * s / PIN_DRAG_SCALE, y * s / PIN_DRAG_SCALE)
					self:SetFrameStrata("TOOLTIP")
					self:StartMoving()
				end
			end
		elseif isMoving and not down then
			isMoving = false
			self:StopMovingOrSizing()
			local x, y = self:GetCenter()
			if not WoW80 then
				local s = WorldMapButton:GetEffectiveScale() / UIParent:GetEffectiveScale()
				self:ClearAllPoints()
				self:SetParent(WorldMapButton)
				x = x / s - WorldMapButton:GetLeft()
				y = y / s - WorldMapButton:GetTop()
				self:SetPoint("CENTER", WorldMapButton, "TOPLEFT", x, y)
				self:SetFrameStrata("TOOLTIP")
				self:SetUserPlaced(false)

				-- Get the new coordinate
				x, y = self:GetCenter()
				x = (x - WorldMapButton:GetLeft()) / WorldMapButton:GetWidth()
				y = (WorldMapButton:GetTop() - y) / WorldMapButton:GetHeight()
			else
				if movingPinScale then
					x = x * PIN_DRAG_SCALE / movingPinScale
					y = y * PIN_DRAG_SCALE / movingPinScale
					self:SetScale(movingPinScale)
					movingPinScale = nil
				end
				local s = self:GetEffectiveScale() / WorldMapFrame.ScrollContainer.Child:GetEffectiveScale()
				x = x * s - WorldMapFrame.ScrollContainer.Child:GetLeft()
				y = y * s - WorldMapFrame.ScrollContainer.Child:GetTop()
				self:ClearAllPoints()
				self:SetParent(WorldMapFrame.ScrollContainer.Child)
				self:SetPoint("CENTER", WorldMapFrame.ScrollContainer.Child, "TOPLEFT", x / self:GetScale(), y / self:GetScale())
				self:SetFrameStrata("TOOLTIP")
				self:SetUserPlaced(false)

				-- Get the new coordinate
				x = x / WorldMapFrame.ScrollContainer.Child:GetWidth()
				y = -y / WorldMapFrame.ScrollContainer.Child:GetHeight()
			end
			-- Move the button back into the map if it was dragged outside
			if x < 0.001 then x = 0.001 end
			if x > 0.999 then x = 0.999 end
			if y < 0.001 then y = 0.001 end
			if y > 0.999 then y = 0.999 end
			local newCoord = HandyNotes:getCoord(x, y)
			-- Search in 4 directions till we find an unused coord
			local count = 0
			local zoneData = dbdata[mapFile]
			while true do
				if not zoneData[newCoord + count] then
					zoneData[newCoord + count] = zoneData[coord]
					break
				elseif not zoneData[newCoord - count] then
					zoneData[newCoord - count] = zoneData[coord]
					break
				elseif not zoneData[newCoord + count * 10000] then
					zoneData[newCoord + count*10000] = zoneData[coord]
					break
				elseif not zoneData[newCoord - count * 10000] then
					zoneData[newCoord - count*10000] = zoneData[coord]
					break
				end
				count = count + 1
			end
			dbdata[mapFile][coord] = nil
			HN:SendMessage("HandyNotes_NotifyUpdate", "HandyNotes")
		end
	end
end

do
	local tablepool = setmetatable({}, {__mode = 'k'})

	if not WoW80 then
		-- This is a custom iterator we use to iterate over every node in a given zone
		local function iter(t, prestate)
			if not t then return end
			local data = t.data
			local level = t.L
			local state, value = next(data, prestate)
			if value then
				while value do -- Have we reached the end of this zone?
					-- Map has no dungeon levels or dungeon level matches
					if not value.level or level == 0 or level == value.level then
						return state, nil, HN.icons[value.icon], db.icon_scale, db.icon_alpha
					end
					state, value = next(data, state) -- Get next data
				end
			end
			wipe(t)
			tablepool[t] = true
		end

		-- This is a funky custom iterator we use to iterate over every zone's nodes
		-- in a given continent + the continent itself
		local function iterCont(t, prestate)
			if not t then return end
			local zone = t.Z
			local mapFile = HandyNotes:GetMapIDtoMapFile(t.C[zone])
			local data = dbdata[mapFile]
			local state, value
			while mapFile do
				if data then -- Only if there is data for this zone
					state, value = next(data, prestate)
					while state do -- Have we reached the end of this zone?
						if value.cont or zone == 0 then -- Show on continent?
							return state, mapFile, HN.icons[value.icon], db.icon_scale, db.icon_alpha
						end
						state, value = next(data, state) -- Get next data
					end
				end
				-- Get next zone
				zone = next(t.C, zone)
				t.Z = zone
				mapFile = HandyNotes:GetMapIDtoMapFile(t.C[zone])
				data = dbdata[mapFile]
				prestate = nil
			end
			wipe(t)
			tablepool[t] = true
		end

		function HNHandler:GetNodes(mapFile, minimap, dungeonLevel)
			local C = HandyNotes:GetContinentZoneList(mapFile) -- Is this a continent?
			if C then
				local tbl = next(tablepool) or {}
				tablepool[tbl] = nil
				tbl.C = C
				tbl.Z = next(C)
				return iterCont, tbl, nil
			else -- It is a zone
				local tbl = next(tablepool) or {}
				tablepool[tbl] = nil
				tbl.data = dbdata[mapFile]
				tbl.L = dungeonLevel
				return iter, tbl, nil
			end
		end
	else
		-- This is a custom iterator we use to iterate over every node in a given zone
		local function iter(t, prestate)
			if not t then return end
			local data = t.data
			local state, value = next(data, prestate)
			if value then
				return state, nil, HN.icons[value.icon], db.icon_scale, db.icon_alpha
			end
			wipe(t)
			tablepool[t] = true
		end

		-- This is a funky custom iterator we use to iterate over every zone's nodes
		-- in a given continent + the continent itself
		local function iterCont(t, prestate)
			if not t then return end
			local zone = t.C[t.Z]
			local data = dbdata[zone]
			local state, value
			while zone do
				if data then -- Only if there is data for this zone
					state, value = next(data, prestate)
					while state do -- Have we reached the end of this zone?
						if value.cont or zone == t.contId then -- Show on continent?
							return state, mapFile, HN.icons[value.icon], db.icon_scale, db.icon_alpha
						end
						state, value = next(data, state) -- Get next data
					end
				end
				-- Get next zone
				t.Z = next(t.C, t.Z)
				zone = t.C[t.Z]
				data = dbdata[zone]
				prestate = nil
			end
			wipe(t)
			tablepool[t] = true
		end

		function HNHandler:GetNodes2(uiMapId, minimap)
			local C = HandyNotes:GetContinentZoneList(uiMapId) -- Is this a continent?
			if C then
				local tbl = next(tablepool) or {}
				tablepool[tbl] = nil
				tbl.C = C
				tbl.Z = next(C)
				tbl.contId = uiMapID
				return iterCont, tbl, nil
			else -- It is a zone
				local tbl = next(tablepool) or {}
				tablepool[tbl] = nil
				tbl.data = dbdata[uiMapId]
				return iter, tbl, nil
			end
		end
	end
end


---------------------------------------------------------
-- HandyNotes core

if not WoW80 then
-- Hooked function on clicking the world map
-- button is guaranteed to be passed in with the WorldMapButton frame
function HN:WorldMapButton_OnClick(button, mouseButton, ...)
	if mouseButton == "RightButton" and IsAltKeyDown() and not IsControlKeyDown() and not IsShiftKeyDown() then
		local mapFile, L = HandyNotes:WhereAmI(), GetCurrentMapDungeonLevel()

		-- Get the coordinate clicked on
		local x, y = GetCursorPosition()
		local scale = button:GetEffectiveScale()
		x = (x/scale - button:GetLeft()) / button:GetWidth()
		y = (button:GetTop() - y/scale) / button:GetHeight()
		local coord = HandyNotes:getCoord(x, y)
		x, y = HandyNotes:getXY(coord)

		-- Pass the data to the edit note frame
		local HNEditFrame = self.HNEditFrame
		HNEditFrame.x = x
		HNEditFrame.y = y
		HNEditFrame.coord = coord
		HNEditFrame.mapFile = mapFile
		HNEditFrame.level = L
		self:FillDungeonLevelData()
		HNEditFrame:Hide() -- Hide first to trigger the OnShow handler
		HNEditFrame:Show()
	else
		return self.hooks[button].OnClick(button, mouseButton, ...)
	end
end

function HN:FillDungeonLevelData()
	local HNEditFrame = self.HNEditFrame
	wipe(HNEditFrame.leveldata)
	-- Note: Even if we're in a microdungeon, the constants are still based off the containing zone
	-- Thus no WhereAmI here.
	local mapname = strupper(GetMapInfo() or "")
	local usesTerrainMap = DungeonUsesTerrainMap() and 1 or 0
	local levels = { GetNumDungeonMapLevels() }
	if #levels > 0 then
		HNEditFrame.leveldata[0] = ALL
	end
	for id, floorNum in pairs(levels) do
		local floorname = _G["DUNGEON_FLOOR_" .. mapname .. floorNum]
		HNEditFrame.leveldata[floorNum] = floorname or string.format(FLOOR_NUMBER, floorNum)
	end
end
end

if WoW80 then
function HN.OnCanvasClicked(mapCanvas, button, cursorX, cursorY)
	local self = HN
	if button == "RightButton" and IsAltKeyDown() and not IsControlKeyDown() and not IsShiftKeyDown() then
		
		local coord = HandyNotes:getCoord(cursorX, cursorY)
		local x, y = HandyNotes:getXY(coord)
		
		-- Pass the data to the edit note frame
		local HNEditFrame = self.HNEditFrame
		HNEditFrame.x = x
		HNEditFrame.y = y
		HNEditFrame.coord = coord
		HNEditFrame.mapID = mapCanvas:GetMapID()
		HNEditFrame:Hide() -- Hide first to trigger the OnShow handler
		HNEditFrame:Show()

		return true
	end
	return false
end
end

-- Function to create a note where the player is
function HN:CreateNoteHere(arg1)
	local mapID, level, x, y

	if arg1 ~= "" then
		-- Coordinates entered
		x, y = string.match(strtrim(arg1), "([%d.]+)[, ]+([%d.]+)")
		x, y = tonumber(x), tonumber(y)
		if x and y and x > 1 and x < 100 and y > 1 and y < 100 then
			-- Normalize coordinates to between 0 and 1
			x, y = x/100, y/100
		end
		if not x or not y or x <= 0 or x >= 1 or y <= 0 or y >= 1 then
			self:Print(L["Syntax:"].." /hnnew [x, y]")
			return
		end
		mapID, level = HBD:GetPlayerZone()
	else
		-- No coordinates entered, get the coordinates of player
		x, y, mapID, level = HBD:GetPlayerZonePosition()
	end

	if mapID and x and y then
		local coord = HandyNotes:getCoord(x, y)
		x, y = HandyNotes:getXY(coord)

		-- Pass the data to the edit note frame
		local HNEditFrame = self.HNEditFrame
		HNEditFrame.x = x
		HNEditFrame.y = y
		HNEditFrame.coord = coord
		HNEditFrame.mapID = mapID
		if not WoW80 then
			HNEditFrame.mapFile = HandyNotes:WhereAmI()
			HNEditFrame.level = GetCurrentMapDungeonLevel()
			self:FillDungeonLevelData()
		end
		HNEditFrame:Hide() -- Hide first to trigger the OnShow handler
		HNEditFrame:Show()
	else
		self:Print(L["ERROR_CREATE_NOTE1"])
	end
end

---------------------------------------------------------
-- Options table
local options = {
	type = "group",
	name = L["HandyNotes"],
	desc = L["HandyNotes"],
	get = function(info) return db[info.arg] end,
	set = function(info, v)
		db[info.arg] = v
		HN:SendMessage("HandyNotes_NotifyUpdate", "HandyNotes")
	end,
	args = {
		desc = {
			name = L["These settings control the look and feel of the HandyNotes icons."],
			type = "description",
			order = 0,
		},
		icon_scale = {
			type = "range",
			name = L["Icon Scale"],
			desc = L["The scale of the icons"],
			min = 0.25, max = 2, step = 0.01,
			arg = "icon_scale",
			order = 10,
		},
		icon_alpha = {
			type = "range",
			name = L["Icon Alpha"],
			desc = L["The alpha transparency of the icons"],
			min = 0, max = 1, step = 0.01,
			arg = "icon_alpha",
			order = 20,
		},
	},
}


---------------------------------------------------------
-- Addon initialization, enabling and disabling

function HN:OnInitialize()
	-- Set up our database
	self.db = LibStub("AceDB-3.0"):New("HandyNotes_HandyNotesDB", defaults)
	db = self.db.profile
	dbdata = self.db.global

	-- migrate data, if neccessary
	if not WoW80 then
		local migration = {}
		for zone in pairs(dbdata) do
			if zone:find("_terrain%d+$") then
				migration[zone] = true
			end
		end

		for zone in pairs(migration) do
			local data = dbdata[zone]
			dbdata[zone] = nil

			local stripped_zone = zone:gsub("_terrain%d+$", "")
			if dbdata[stripped_zone] then
				for coord, info in pairs(data) do
					dbdata[stripped_zone][coord] = info
				end
			else
				dbdata[stripped_zone] = data
			end
		end
	else
		local HBDMigrate = LibStub("HereBeDragons-Migrate")
		
		local migration = {}
		for zone in pairs(dbdata) do
			if type(zone) == "string" then
				migration[zone] = true
			end
		end
		
		for zone in pairs(migration) do
			local data = dbdata[zone]
			dbdata[zone] = nil

			local stripped_zone = zone:gsub("_terrain%d+$", "")
			for coord, info in pairs(data) do
				local newzone = HBDMigrate:GetUIMapIDFromMapFile(stripped_zone, info.level)
				if newzone then
					info.level = nil
					if not dbdata[newzone] then
						dbdata[newzone] = {}
					end
					dbdata[newzone][coord] = info
				end
			end
			
		end
	end
	HNData = dbdata

	-- Initialize our database with HandyNotes
	HandyNotes:RegisterPluginDB("HandyNotes", HNHandler, options)

	--WorldMapMagnifyingGlassButton:SetText(WorldMapMagnifyingGlassButton:GetText() .. L["\nAlt+Right Click To Add a HandyNote"])
	if WoW80 then
		WorldMapFrame:AddCanvasClickHandler(self.OnCanvasClicked)
	end

	-- Slash command
	self:RegisterChatCommand("hnnew", "CreateNoteHere")
end

function HN:OnEnable()
	if not WoW80 then
		self:RawHookScript(WorldMapButton, "OnClick", "WorldMapButton_OnClick")
	end
end

function HN:OnDisable()
end
