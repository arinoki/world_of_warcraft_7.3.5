if not UIDROPDOWNMENU_MINWIDTH_PATCH_VERSION and select(4,GetBuildInfo()) < 80000 then
	local THIS_VERSION = 1
	UIDROPDOWNMENU_MINWIDTH_PATCH_VERSION = THIS_VERSION
	hooksecurefunc("UIDropDownMenu_InitializeHelper", function()
		if UIDROPDOWNMENU_MINWIDTH_PATCH_VERSION ~= THIS_VERSION then
			return
		end
		for i = UIDROPDOWNMENU_MENU_LEVEL, UIDROPDOWNMENU_MAXLEVELS do
			_G["DropDownList" .. i].fxMinWidth = nil
		end
	end)
	hooksecurefunc("UIDropDownMenu_AddButton", function(info, level)
		if UIDROPDOWNMENU_MINWIDTH_PATCH_VERSION ~= THIS_VERSION then
			return
		end
		if type(info) ~= "table" or type(info.minWidth) ~= "number" then
			return
		end
		local minWidth, list = info.minWidth, _G["DropDownList" .. (level or 1)]
		list.fxMinWidth = list.fxMinWidth and math.max(list.fxMinWidth, minWidth) or minWidth
	end)
	hooksecurefunc("UIDropDownMenu_RefreshDropDownSize", function(self)
		if UIDROPDOWNMENU_MINWIDTH_PATCH_VERSION ~= THIS_VERSION then
			return
		end
		if self.maxWidth >= (self.fxMinWidth or 0) then
			return
		end
		local minWidth = self.fxMinWidth
		self:SetWidth(minWidth + 25)
		
		for i=1, UIDROPDOWNMENU_MAXBUTTONS do
			local icon = _G[self:GetName() .. "Button" .. i .. "Icon"]
			if icon.tFitDropDownSizeX then
				icon:SetWidth(minWidth - 5)
			end
		end
	end)
end

if (UIDROPDOWNMENU_VALUE_PATCH_VERSION or 0) < 2 then
	UIDROPDOWNMENU_VALUE_PATCH_VERSION = 2
	hooksecurefunc("UIDropDownMenu_InitializeHelper", function()
		if UIDROPDOWNMENU_VALUE_PATCH_VERSION ~= 2 then
			return
		end
		for i=1, UIDROPDOWNMENU_MAXLEVELS do
			for j=1, UIDROPDOWNMENU_MAXBUTTONS do
				local b = _G["DropDownList" .. i .. "Button" .. j]
				if not (issecurevariable(b, "value") or b:IsShown()) then
					b.value = nil
					repeat
						j, b["fx" .. j] = j+1
					until issecurevariable(b, "value")
				end
			end
		end
	end)
end