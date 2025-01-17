local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")
local Tools = SLE:NewModule("Toolbars", 'AceHook-3.0', 'AceEvent-3.0')
--GLOBALS: CreateFrame, hooksecurefunc, UIParent
local size
local Zcheck = false
local _G = _G
local GameTooltip = GameTooltip
local PickupContainerItem, DeleteCursorItem = PickupContainerItem, DeleteCursorItem

Tools.RegisteredAnchors = {}
Tools.buttoncounts = {} --To kepp number of items

function Tools:InventoryUpdate(event)
	if T.InCombatLockdown() then
		Tools:RegisterEvent("PLAYER_REGEN_ENABLED", "InventoryUpdate")
		return
	else
		Tools:UnregisterEvent("PLAYER_REGEN_ENABLED")
 	end

	local updateRequired = false
	for name, anchor in T.pairs(Tools.RegisteredAnchors) do
		if not anchor.InventroyCheck then assert(false, "Anchor named "..name.."doesn't have inventory update.") return end
		if anchor.InventroyCheck() then updateRequired = true; break end
	end

	if event and event ~= "BAG_UPDATE_COOLDOWN" and updateRequired == true then
		Tools:UpdateLayout()
	end
end

Tools.UpdateBarLayout = function(bar, anchor, buttons, category, db)
	if not db.enable then return end
	local count = 0

	bar:ClearAllPoints()
	bar:Point("LEFT", anchor, "LEFT", 0, 0)
	for i, button in T.ipairs(buttons) do
		button:ClearAllPoints()
		if not button.items then Tools:InventoryUpdate() end
		if not db.active or button.items > 0 then
			button:Point("TOPLEFT", bar, "TOPLEFT", (count * (db.buttonsize+(2 - E.Spacing)))+(1 - E.Spacing), -1)
			button:Show()
			button:Size(db.buttonsize, db.buttonsize)
			count = count + 1
		else
			button:Hide()
		end
	end
	
	bar:Width(1)
	bar:Height(db.buttonsize+2)
	
	return count
end

local function UpdateCooldown(anchor)
	if not anchor.ShouldShow() then return end

	for i = 1, anchor.NumBars do
		local bar = anchor.Bars[anchor.BarsName..i]
		for _, button in T.ipairs(bar.Buttons) do
			if button.cooldown then button.cooldown:SetCooldown(T.GetItemCooldown(button.itemId)) end
		end
	end
end

local function UpdateBar(bar, layoutfunc, zonecheck, anchor, buttons, category, returnDB)
	bar:Show()

	local db = returnDB()
	local count = layoutfunc(bar, anchor, buttons, category, db)
	if (db.enable and (count and count > 0) and zonecheck() and not T.InCombatLockdown()) then
		bar:Show()
	else
		bar:Hide()
	end
end

function Tools:BAG_UPDATE_COOLDOWN()
	Tools:InventoryUpdate()
	for name, anchor in T.pairs(Tools.RegisteredAnchors) do
		UpdateCooldown(anchor)
	end
end

local function Zone(event)
	local shouldShow = false
	for name, anchor in T.pairs(Tools.RegisteredAnchors) do
		if not anchor.ShouldShow or anchor.ShouldShow() then
			shouldShow = true
			break
		end
	end

	if shouldShow then
		Tools:RegisterEvent("BAG_UPDATE", "InventoryUpdate")
		Tools:RegisterEvent("BAG_UPDATE_COOLDOWN")
		Tools:RegisterEvent("UNIT_QUEST_LOG_CHANGED", "UpdateLayout")
		Tools:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "InventoryUpdate")

		Tools:InventoryUpdate(event)
		Tools:UpdateLayout()
		Zcheck = true
	else
		Tools:UnregisterEvent("BAG_UPDATE")
		Tools:UnregisterEvent("BAG_UPDATE_COOLDOWN")
		Tools:UnregisterEvent("UNIT_QUEST_LOG_CHANGED")
		Tools:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		if Zcheck then
			Tools:UpdateLayout()
			Zcheck = false
		end
	end
end

function Tools:UpdateLayout(event, unit) --don't touch
	--For updating borders after quest was complited. for some reason events fires before quest disappeares from log
	if event == "UNIT_QUEST_LOG_CHANGED" then
		if unit == "player" then E:Delay(1, Tools.UpdateLayout) else return end
	end 
	if T.InCombatLockdown() then
		Tools:RegisterEvent("PLAYER_REGEN_ENABLED", "UpdateLayout")	
		return
	else
		Tools:UnregisterEvent("PLAYER_REGEN_ENABLED")
 	end
	for name, anchor in T.pairs(Tools.RegisteredAnchors) do
		if anchor.mover then
			if anchor.EnableMover() then
				E:EnableMover(anchor.mover:GetName())
			else
				E:DisableMover(anchor.mover:GetName())
			end
		end
		for i = 1, anchor.NumBars do
			local bar = anchor.Bars[anchor.BarsName..i]
			UpdateBar(bar, anchor.UpdateBarLayout, bar.zonecheck, anchor, bar.Buttons, bar.id, anchor.ReturnDB)
		end
		anchor.Resize(anchor)
	end
end

local function onClick(self, mousebutton)
	if mousebutton == "LeftButton" then
		if T.InCombatLockdown() and not self.macro then
			SLE:Print(L["We are sorry, but you can't do this now. Try again after the end of this combat."])
			return
		end
		self:SetAttribute("type", self.buttonType)
		self:SetAttribute(self.buttonType, self.sortname)
		local bar = self:GetParent()
		if bar.Autotarget then bar.Autotarget(self) end
		if self.cooldown then 
			self.cooldown:SetCooldown(T.GetItemCooldown(self.itemId))
		end
		if not self.macro then self.macro = true end
	elseif mousebutton == "RightButton" and self.allowDrop then
		self:SetAttribute("type", "click")
		local container, slot = SLE:BagSearch(self.itemId)
		if container and slot then
			PickupContainerItem(container, slot)
			DeleteCursorItem()
		end
	end
	Tools:InventoryUpdate()
end

local function onEnter(self)
	GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT', 2, 4)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(" ")
	GameTooltip:SetItemByID(self.itemId) 
	if self.allowDrop then
		GameTooltip:AddLine(L["Right-click to drop the item."])
	end
	GameTooltip:Show()
end

local function onLeave()
	GameTooltip:Hide() 
end

function Tools:CreateToolsButton(index, owner, buttonType, name, texture, allowDrop, db)
	size = db.buttonsize
	local button = CreateFrame("Button", T.format("ToolsButton%d", index), owner, "SecureActionButtonTemplate")
	button:Size(size, size)
	S:HandleButton(button)

	button.sortname = name
	button.itemId = index
	button.allowDrop = allowDrop
	button.buttonType = buttonType
	button.macro = false

	button.icon = button:CreateTexture(nil, "ARTWORK")
	button.icon:SetTexture(texture)
	button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	button.icon:SetInside()

	button.text = button:CreateFontString(nil, "OVERLAY")
	button.text:SetFont(E.media.normFont, 12, "OUTLINE")
	button.text:SetPoint("BOTTOMRIGHT", button, 1, 2)

	if T.select(3, T.GetItemCooldown(button.itemId)) == 1 then
		button.cooldown = CreateFrame("Cooldown", T.format("ToolsButton%dCooldown", index), button)
		button.cooldown:SetAllPoints(button)
		E:RegisterCooldown(button.cooldown)
	end

	button:HookScript("OnEnter", onEnter)
	button:HookScript("OnLeave", onLeave)
	button:SetScript("OnMouseDown", onClick)
	
	return button
end

function Tools:PopulateBar(bar)
	bar = _G[bar]
	if not bar then return end
	if not bar.Buttons then bar.Buttons = {} end
	for id, data in T.pairs(bar.Items) do
		T.tinsert(bar.Buttons, Tools:CreateToolsButton(id, bar, "item", data[1], data[10], true, E.db.sle.legacy.farm))
		T.sort(bar.Buttons, function(a, b)
			if not a or not b then return true end
			return a.sortname < b.sortname
		end)
	end
end

function Tools:CreateFrames()
	for name, anchor in T.pairs(Tools.RegisteredAnchors) do
		if not anchor.Initialized then
			for bar, data in T.pairs(anchor.Bars) do
				Tools:PopulateBar(bar)
			end
			anchor.Initialized = true
		end
	end
	if not Tools.EventsRegistered then
		Tools:RegisterEvent("ZONE_CHANGED", Zone)
		Tools:RegisterEvent("ZONE_CHANGED_NEW_AREA", Zone)
		Tools:RegisterEvent("ZONE_CHANGED_INDOORS", Zone)
		Tools:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "InventoryUpdate")
		Tools.EventsRegistered = true
	end

	E:Delay(5, Zone)
end

local function RecreateAnchor(anchor)
	for bar, data in T.pairs(anchor.Bars) do
		for id, info in T.pairs(data.Items) do
			if T.type(info) == "number" and T.GetItemInfo(id) == nil then 
				E:Delay(5, function() RecreateAnchor(anchor) end)
				return
			else
				data.Items[id] = { T.GetItemInfo(id) }
			end
		end
	end

	if not anchor.Initialized then 
		local name = anchor:GetName()
		Tools.RegisteredAnchors[name] = anchor
		Tools:CreateFrames()
	end
end

function Tools:RegisterForBar(func)
	local anchor = func()

	RecreateAnchor(anchor)
end

function Tools:Initialize()
	if not SLE.initialized then return end

	function Tools:ForUpdateAll()
		Tools:UpdateLayout()
	end
end

SLE:RegisterModule(Tools:GetName())
