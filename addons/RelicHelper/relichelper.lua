local addonName, addonTable, _ = ...
local name, _, _, enabled = GetAddOnInfo("tekDebug")
local player = UnitName("player")
local enabled = GetAddOnEnableState(player, "tekDebug") == 2
if enabled and not IsAddOnLoaded("tekDebug") then
  local succ, err = LoadAddOn(name)
end
local debugf = tekDebug and tekDebug:GetFrame(addonName)
local function DebugPrint(...) if debugf then debugf:AddMessage(string.join(", ", tostringall(...))) end end
DebugPrint("RelicHelper loaded.")

local OpenedRelicInfo         = C_ArtifactUI.GetRelicInfo

local RELIC_TOOLTIP_TYPE_PATTERN = _G.RELIC_TOOLTIP_TYPE:gsub('%%s', '(.+)')
-- local GetILVLIncByRelic       = C_ArtifactUI.GetItemLevelIncreaseProvidedByRelic
-- Tooltip scan workaround because C_ArtifactUI.GetItemLevelIncreaseProvidedByRelic is fucked since 7.2.0
local relicScanTT = CreateFrame('GameTooltip', 'RelicHelperTooltipScanBecauseBlizzardCantGetTheirShitTogetherItSeems', UIParent, 'GameTooltipTemplate')

-- Start line 4, Name, Itemlevel and Bind on XY are at least 3 at the top and we should reach it at line 8 maxLine
local TTSCAN_START_LINE = 4
local TTSCAN_MAX_LINE = 8
local RELIC_TOOLTIP_ILVL_PATTERN = _G.RELIC_TOOLTIP_ILVL_INCREASE:gsub('%%d', '(.+)')
 
local function GetILVLIncByRelic(relicLink)
  local ilvlIncrease = C_ArtifactUI.GetItemLevelIncreaseProvidedByRelic(relicLink)
  if not ilvlIncrease then
    ilvlIncrease = 0
    relicScanTT:SetOwner(UIParent, 'ANCHOR_NONE')
    relicScanTT:SetHyperlink(relicLink)
    local maxLine, currLine  = ( relicScanTT:NumLines() > TTSCAN_MAX_LINE ) and TTSCAN_MAX_LINE or relicScanTT:NumLines();
    for currLine = TTSCAN_START_LINE, maxLine do
    textFrame = _G[relicScanTT:GetName() .. "TextLeft" .. currLine];
    if (textFrame:IsVisible()) then
        local ilvlMatch  = textFrame:GetText() and textFrame:GetText():match(RELIC_TOOLTIP_ILVL_PATTERN);
        if ilvlMatch then
          ilvlIncrease = ilvlMatch
        end
    end
    end
    relicScanTT:Hide()
  end
  return ilvlIncrease
end




local GetRelicSlotType
local GetNumRelicSlots

-- Used for Encounter Journal scanning
local lastUpdate = 0
local dataArriveButNotProcessed = false

RelicHelper_SV = RelicHelper_SV or {}

local MAX_RELIC_NUM = 3
local currChar = UnitName("player").."-"..GetRealmName()-- Unique name-realm identifier for database storage
DebugPrint("currChar", currChar)

local RH = CreateFrame("Frame")

-- All keys of the table will be RegisterEvent'd at the end of the file
RH.Events = {}

RH:SetScript("OnEvent",function( self, event, ...)
  DebugPrint(event,...)
  self.Events[event](self, ...)
end)


RH.Events["ADDON_LOADED"] = function( self, loadedAddon )
  if loadedAddon ~= addonName then return end
  self:UnregisterEvent("ADDON_LOADED")
end

RH.Events["PLAYER_ENTERING_WORLD"] = function( self )
  self:ScanEJForRelics()
  self:ScanArtifact()
end

RH.Events["ARTIFACT_UPDATE"] = function( self )
  self:ScanArtifact()
  if dataArriveButNotProcessed then
    -- EJ recieved new data but we did not check it yet
    if UnitAffectingCombat("player ") or ( GetTime() - lastUpdate ) < 120 then
      -- Don't scan it in combat or when it  last scan was not that long ago.
      return
    end
    self:ScanEJForRelics()
  end
end

function RH:ScanArtifact()
  if not ArtifactFrame:IsShown() then return end

  local artifactName = C_ArtifactUI.GetArtifactArtInfo().titleName
  if not artifactName then return end

  self:UpdateDB(artifactName)

  -- Change functions depending scannig equipped vs open artifact
  OpenedRelicInfo  = C_ArtifactUI.GetRelicInfo
  GetRelicSlotType = function (index)
                       return _G["RELIC_SLOT_TYPE_"..string.upper(C_ArtifactUI.GetRelicSlotType(index))]
                     end
  GetNumRelicSlots = C_ArtifactUI.GetNumRelicSlots
  if GetNumRelicSlots() > 0 then
    local relicData = RelicHelper_SV[currChar][artifactName]
    for i=1,MAX_RELIC_NUM do
      local _, relicName, relicItemID, relicItemLink = OpenedRelicInfo(i)
      local relicType = GetRelicSlotType(i)
      relicData[i]["ilvlBonus"] = (relicItemLink and GetILVLIncByRelic( relicItemLink ) or 0)
      relicData[i]["type"]      = relicType or relicData[i]["type"]
      DebugPrint(artifactName, relicName or "Empty relic slot", relicData[i]["ilvlBonus"], relicData[i]["type"] )
    end
  end
end
ArtifactFrame:HookScript("OnShow", function(...)
  RH:ScanArtifact()
end)


function RH:UpdateDB(artifactName)
  if not artifactName then
    artifactName = "Somethingwenthorriblywrong"
  end
  RelicHelper_SV[currChar] = RelicHelper_SV[currChar] or {}
  RelicHelper_SV[currChar][artifactName] = RelicHelper_SV[currChar][artifactName] or {}
  for i=1,MAX_RELIC_NUM do
    RelicHelper_SV[currChar][artifactName][i] = RelicHelper_SV[currChar][artifactName][i] or {}
  end
end


local relinquishedRelicItemID2Relic = {
  [153059] = RELIC_SLOT_TYPE_ARCANE,
  [153060] = RELIC_SLOT_TYPE_BLOOD,
  [153061] = RELIC_SLOT_TYPE_FEL,
  [153062] = RELIC_SLOT_TYPE_FIRE,
  [153063] = RELIC_SLOT_TYPE_FROST,
  [153064] = RELIC_SLOT_TYPE_HOLY,
  [153065] = RELIC_SLOT_TYPE_IRON,
  [153066] = RELIC_SLOT_TYPE_LIFE,
  [153067] = RELIC_SLOT_TYPE_SHADOW,
  [153068] = RELIC_SLOT_TYPE_WIND,
}

function RH.manageTooltip(tooltip, ... )
  local _, link = tooltip:GetItem()
  if not link then return end
  local ilvlBonus = GetILVLIncByRelic(link) or 0
  local _, itemId = strsplit(":", link)
  itemId = tonumber(itemId)
  DebugPrint("RH.manageRelinquishedRelicTooltip", itemId, relinquishedRelicItemID2Relic[itemId])
  if relinquishedRelicItemID2Relic[itemId] then
	-- Hard code the +61 ilvls here
    RH.manageRelinquishedRelicTooltip(tooltip, relinquishedRelicItemID2Relic[itemId], 61)
	return
  end
  if select(7, GetItemInfo(link)) == EJ_LOOT_SLOT_FILTER_ARTIFACT_RELIC then
    local relicType, t, i, j
    for i=1,tooltip:NumLines() do
      if relicType then break end
      local t = _G[tooltip:GetName().."TextLeft"..i]:GetText() or ""
      relicType = t:match(RELIC_TOOLTIP_TYPE_PATTERN)
    end
    DebugPrint(link, ilvlBonus, relicType or "no type" )


    if relicType then
      local data = RelicHelper_SV[currChar]
      for i=1,tooltip:NumLines() do
        local currLine = _G[tooltip:GetName().."TextLeft"..i]
        local currLineText = currLine:GetText()
        if data and data[currLineText] then
          DebugPrint(i, currLineText)
          for j=1,MAX_RELIC_NUM do
            --if relicType == data[currLineText][j]["type"] and ilvlBonus > data[currLineText][j]["ilvlBonus"] then
            DebugPrint(ilvlBonus, data[currLineText][j]["type"], data[currLineText][j]["ilvlBonus"])
            if relicType == data[currLineText][j]["type"] then
              local relBonus = ilvlBonus - data[currLineText][j]["ilvlBonus"]
              currLine:SetText(currLine:GetText() .. ( relBonus > 0 and " (|cFF00FF00+" or  " (|cFFFF0000").. relBonus.."|r)")
            end
          end
        end
      end
    end
  end
  tooltip:Show()
end

function RH.manageRelinquishedRelicTooltip(tooltip, relicType, iLVLBonus)
  local data = RelicHelper_SV[currChar]
  for currArtifactName, currArtifactData in pairs(data) do
	local lineToAdd, found = currArtifactName..":", false
	DebugPrint(i, currLineText)
	for j=1,MAX_RELIC_NUM do
	  DebugPrint(iLVLBonus, currArtifactData[j]["type"], currArtifactData[j]["ilvlBonus"])
	  if relicType == currArtifactData[j]["type"] then
	    local relBonus = iLVLBonus - currArtifactData[j]["ilvlBonus"]
	    lineToAdd = lineToAdd .. ( relBonus > 0 and " (|cFF00FF00+" or  " (|cFFFF0000").. relBonus.."|r)"
	    found = true
	  end
    end
	if found then
	  tooltip:AddLine(lineToAdd)
	end
  end
end

-- overload the base function for ItemRefTooltip with a custom routine
ItemRefTooltip:HookScript("OnTooltipSetItem", function(tooltip, ...)
  RH.manageTooltip(tooltip, ...)
end)
GameTooltip:HookScript("OnTooltipSetItem", function(tooltip, ...)
  RH.manageTooltip(tooltip, ...)
end)
WorldMapTooltip.ItemTooltip.Tooltip:HookScript("OnTooltipSetItem", function(tooltip, ...)
  RH.manageTooltip(tooltip, ...)
end)


-- Testing stuff
RH.relicsDropsByEncouter = {}
function RH:ScanEJForRelics()
  dataArriveButNotProcessed = false
  lastUpdate = GetTime()
  local foundRelics = 0
  self.relicsDropsByEncouter = {}
  -- Set Loot Filter: All Specs
  EJ_SetLootFilter(select(3, UnitClass("player")))
  -- Mythic, so all the dungeons show their loot
  EJ_SetDifficulty(23)
  -- Select Legion
  EJ_SelectTier(7)

  local i, instanceID, instanceName = 1

  -- Iterate all the instances
  instanceID, instanceName = EJ_GetInstanceByIndex(i, false)
  while instanceID do
    foundRelics = foundRelics + self:ScanEncountersForRelics(instanceID)
    i = i +1
    instanceID, instanceName = EJ_GetInstanceByIndex(i, false)
  end

  -- Do the same for raids
  i = 1

  instanceID, instanceName = EJ_GetInstanceByIndex(i, true)
  while instanceID do
    foundRelics = foundRelics + self:ScanEncountersForRelics(instanceID)
    i = i +1
    instanceID, instanceName = EJ_GetInstanceByIndex(i, true)
  end

  DebugPrint("ScanEJForRelics", foundRelics, "relics found")
end

function RH:ScanEncountersForRelics(instanceID)
  local relics = 0
  local k, j, encounterName, encounterID, creatIndex = 1, 1
  encounterName, _, encounterID = EJ_GetEncounterInfoByIndex(j, instanceID)
  EJ_SelectInstance(instanceID)
  -- Iterate all the encouters
  while encounterID do

    EJ_SelectEncounter(encounterID)
    -- Iterate all the loots
    for k = 1, EJ_GetNumLoot() do

      local _, _, _, _, slot, _, link = EJ_GetLootInfoByIndex(k)
      local relicType = slot and  slot:match(RELIC_TOOLTIP_TYPE_PATTERN)
      if relicType then
        relics = relics + 1

        for creatIndex = 1, 6 do
          local creatureName = select(2, EJ_GetCreatureInfo(creatIndex,encounterID))
          if creatureName then
            self.relicsDropsByEncouter[creatureName] = self.relicsDropsByEncouter[creatureName] or {}
            table.insert(self.relicsDropsByEncouter[creatureName], relicType)
          end
        end
      end

    end

    j = j +1
    encounterName, _, encounterID = EJ_GetEncounterInfoByIndex(j, instanceID)
  end
  return relics
end

RH.Events["GET_ITEM_INFO_RECEIVED"] = function(self)
  if UnitAffectingCombat("player ") or ( GetTime() - lastUpdate ) < 120 then
    -- Don't scan it in combat or when it  last scan was not that long ago.
    dataArriveButNotProcessed = true
    return
  end
  self:ScanEJForRelics()
end

GameTooltip:HookScript("OnTooltipSetUnit", function(tooltip, ...)
  local name = tooltip:GetUnit()
  local relicsString
  if RH.relicsDropsByEncouter[name] then
    relicsString = table.concat(RH.relicsDropsByEncouter[name], ", ")
  end
  DebugPrint("OnTooltipSetUnit", name, relicsString)
  if relicsString then
    tooltip:AddLine("RelicHelper: ".. relicsString)
  end
end)

for key,value in pairs(RH.Events) do
    RH:RegisterEvent(key)
end
