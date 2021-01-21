--[[
	TorghastHelper is a simple World of Warcraft addon.
    Copyright (C) 2020 Ignifazius

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
0
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]
TorghastHelper = {}
local TAG = "TH"
local name, addon = ...
local _, L = ...
local isRSoulPresent = false
local soulLocation = {}
local isInfuserPresent = false
local infuserLocation = {}
local alwaysDisplayTraits, showBuffName, showDescription
local buttonFrame

local eventResponseFrame = CreateFrame("Frame", "Helper")
	eventResponseFrame:RegisterEvent("PLAYER_LOGIN")
	eventResponseFrame:RegisterEvent("PLAYER_LOGOUT")
	eventResponseFrame:RegisterEvent("ZONE_CHANGED")
	eventResponseFrame:RegisterEvent("ZONE_CHANGED_INDOORS")
	eventResponseFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	eventResponseFrame:RegisterEvent("INSTANCE_GROUP_SIZE_CHANGED")
	

function TorghastHelper.registerAddon()
	eventResponseFrame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	eventResponseFrame:RegisterEvent("CURSOR_UPDATE")
	eventResponseFrame:RegisterEvent("BAG_UPDATE")
	--print("TorghastHelper active")
end

function TorghastHelper.unregisterAddon()
	eventResponseFrame:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
	eventResponseFrame:UnregisterEvent("CURSOR_UPDATE")
	eventResponseFrame:UnregisterEvent("BAG_UPDATE")
	--print("TorghastHelper inactive")
end

local function eventHandler(self, event, arg1, arg2, arg3, arg4, arg5)
    if (event == "UPDATE_MOUSEOVER_UNIT") then
        TorghastHelper.function__wait(0.1, TorghastHelper.addValueToTooltip)
    elseif (event == "CURSOR_UPDATE") then
        TorghastHelper.function__wait(0.1, TorghastHelper.addValueToTooltip)
	elseif(event == "PLAYER_LOGIN") then
		TorghastHelper.loadSV()
		TorghastHelper.createMenuFrame()
		TorghastHelper.toggleAddon()
		TorghastHelper.createButtonBar()
		TorghastHelper.toggleButtonBar()
	elseif(event == "PLAYER_LOGOUT") then
		TorghastHelper.saveSV()
	elseif (event == "BAG_UPDATE" or event == "INSTANCE_GROUP_SIZE_CHANGED") then
		TorghastHelper.scanForItems()
    end			  
	if event == "ZONE_CHANGED_NEW_AREA" then --entering/leaving torghast
		TorghastHelper.toggleAddon()
		TorghastHelper.toggleButtonBar()
	end
	--print(event)
end
eventResponseFrame:SetScript("OnEvent", eventHandler)


function TorghastHelper.toggleAddon() 
	if TorghastHelper.isInTorghast() then
		TorghastHelper.registerAddon()
	else 
		TorghastHelper.unregisterAddon()
	end
end

function TorghastHelper.isInTorghast()
	local id = C_Map.GetBestMapForUnit("player")
	if id ~= nil then
		local mapinfo = C_Map.GetMapInfo(id)
		--mapid = mapinfo.mapID
		name = mapinfo.name
		--typ = mapinfo.mapType
		--parent = mapinfo.parentMapID
		--flags = mapinfo.flags
		--print(mapid, name, typ, parent, flags)
		if name == "Torghast" then --too many ids: id == 1758 (Skoldus Hall lvl 1), id = 1627 (Skoldus Hall lvl 2) etc.
			return true
		end
	end
	return false
end


function TorghastHelper.createButtonBar()
	buttonFrame = CreateFrame("Frame", "thButtonFrame", UIParent, "BackdropTemplate")
		buttonFrame:SetSize(125, 70)
		buttonFrame:SetPoint("CENTER")
		buttonFrame:SetBackdrop({
			bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
			edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
			edgeSize = 1,
		})
		buttonFrame:SetBackdropColor(0, 0, 0, .5)
		buttonFrame:SetBackdropBorderColor(0, 0, 0)
		buttonFrame:SetMovable(true)
		buttonFrame:EnableMouse(true)
		buttonFrame:RegisterForDrag("LeftButton")
		buttonFrame:SetScript("OnDragStart", buttonFrame.StartMoving)
		buttonFrame:SetScript("OnDragStop", buttonFrame.StopMovingOrSizing)

	local ib = CreateFrame("Button", "infuserButton", buttonFrame, "SecureActionButtonTemplate")
		ib:SetSize(50,50)
		ib:SetPoint("TOPLEFT",10,-10)
		local infuserIcon = "Interface\\Icons\\spell_burningsoul"
		ib:SetNormalTexture(infuserIcon)
		ib:SetHighlightTexture(infuserIcon)
		ib:GetHighlightTexture(infuserIcon):SetVertexColor(0.5, 0.5, 0.5)

		local infuserName = GetItemInfo(184652)
		ib:SetAttribute("type", "item");
		ib:SetAttribute("item", infuserName)
		
	local sb = CreateFrame("Button", "soulButton", buttonFrame, "SecureActionButtonTemplate")
		sb:SetSize(50,50)
		sb:SetPoint("TOPLEFT",65,-10)
		local soulIcon = "Interface\\Icons\\inv_misc_orb_05"
		sb:SetNormalTexture(soulIcon)
		sb:SetHighlightTexture(soulIcon)
		sb:GetHighlightTexture(soulIcon):SetVertexColor(0.5, 0.5, 0.5)
			
		local soulName = GetItemInfo(170540)
		sb:SetAttribute("type", "item");
		sb:SetAttribute("item", soulName)


end

function TorghastHelper.getInfuserLoc()
	print(infuserLocation.container.." "..infuserLocation.slot)
	return infuserLocation.container.." "..infuserLocation.slot
end

function TorghastHelper.toggleButtonBar()
	if TorghastHelper.isInTorghast() then
		buttonFrame:Show()
	else
		buttonFrame:Hide()
	end
end

function TorghastHelper.getMouseOverID()
	_, unit = GameTooltip:GetUnit()
	if unit ~= nil then
		local guid = UnitGUID(unit)
		local id = tonumber(strmatch(guid, '%-(%d-)%-%x-$'), 10)
		return id
	end
end

function TorghastHelper.addValueToTooltip()	
	local unitID = TorghastHelper.getMouseOverID()
	if (unitID ~= nil) then
		local infoText = ""
		if (isRSoulPresent or alwaysDisplayTraits) and addon.values[unitID] ~= nil and addon.values[unitID]["effect"] ~= nil and addon.values[unitID]["effect"]["id"] ~= nil then
			infoText = GetSpellDescription(addon.values[unitID]["effect"]["id"])
		end
		if addon.rares[unitID] ~= nil then
			local buffs = addon.rares[unitID]["buffs"]
			for i = 1, #buffs do
				local buff = addon.rares[unitID]["buffs"][i]
				local spellID = addon.descriptions[buff]["id"]
				local spellName = GetSpellInfo(spellID)
				infoText = infoText..i..": "
				
				if showBuffName and showDescription then
					infoText = infoText.."\n["
				end
				
				if showBuffName then
					infoText = infoText..spellName	
				end
				
				if showBuffName and showDescription then
					infoText = infoText.."] "
				else
					infoText = infoText.."\n"
				end
				
				if showDescription then
					infoText = infoText..GetSpellDescription(spellID).."\n"
				end
			end
		end
		if infoText ~= nil and infoText ~= "" and TorghastHelper.checkTooltipForDuplicates() then
			GameTooltip:AddLine(TAG..":\n"..infoText, 0.9, 0.8, 0.5, 1, 0)
			GameTooltip:Show()
		end
	end
end

local configFrame = CreateFrame('Frame')
local configTitle = nil
local configAlwaysDisplay = nil
local configShowBuffName = nil
local configShowDescription = nil

function TorghastHelper.createMenuFrame()
	TorghastHelper.createConfigFrame()
	configFrame.name = "TorghastHelper"
	configFrame.refresh = TorghastHelper.refresh()
	InterfaceOptions_AddCategory(configFrame)
end

function TorghastHelper.refresh()
	configAlwaysDisplay:SetChecked(alwaysDisplayTraits)
	configShowBuffName:SetChecked(showBuffName)
	configShowDescription:SetChecked(showDescription)
end

function TorghastHelper.createConfigFrame()
	configTitle = configFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    configTitle:SetPoint("TOPLEFT", 16, -16)
    configTitle:SetText("Torghast Helper")
	
	configAlwaysDisplay = TorghastHelper.createCheckbox(
    	"Always Show Anima Powers",
    	"This will allow you to always see the Anima Powers you will get when using the Ravenous Anima Soul, regardless of currently possessing it",
    	function(self, value) TorghastHelper.DisplayAlways(value) end)
    configAlwaysDisplay:SetPoint("TOPLEFT", configTitle, "BOTTOMLEFT", 0, -8)
	
	configShowBuffName = TorghastHelper.createCheckbox(
		"Show Rare Buff Name",
		"Shows the name of the buff of a rare mob",
		function(self, value) TorghastHelper.ShowBuffName(value) end)
	configShowBuffName:SetPoint("TOPLEFT", configTitle, "BOTTOMLEFT", 0, -30)
	
	configShowDescription = TorghastHelper.createCheckbox(
		"Show Rare Buff Description",
		"Shows the detailed description of the buff of a rare mob",
		function(self, value) TorghastHelper.ShowDescription(value) end)
	configShowDescription:SetPoint("TOPLEFT", configTitle, "BOTTOMLEFT", 0, -52)
end

function TorghastHelper.DisplayAlways(bool)
	alwaysDisplayTraits = bool
end

function TorghastHelper.ShowBuffName(bool)
	showBuffName = bool
end

function TorghastHelper.ShowDescription(bool)
	showDescription = bool
end

function TorghastHelper.createCheckbox(label, description, onClick)
	local check = CreateFrame("CheckButton", "IAConfigCheckbox" .. label, configFrame, "InterfaceOptionsCheckButtonTemplate")
	check:SetScript("OnClick", function(self)
		PlaySound(self:GetChecked() and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
		onClick(self, self:GetChecked() and true or false)
	end)
	check.label = _G[check:GetName() .. "Text"]
	check.label:SetText(label)
	check.tooltipText = label
	check.tooltipRequirement = description
	return check
end

local waitTable = {}
local waitFrame = nil

function TorghastHelper.function__wait(delay, func, ...)
  if(type(delay)~="number" or type(func)~="function") then
    return false
  end
  if(waitFrame == nil) then
    waitFrame = CreateFrame("Frame","WaitFrame", UIParent)
    waitFrame:SetScript("onUpdate",function (self,elapse)
      local count = #waitTable
      local i = 1
      while(i<=count) do
        local waitRecord = tremove(waitTable,i)
        local d = tremove(waitRecord,1)
        local f = tremove(waitRecord,1)
        local p = tremove(waitRecord,1)
        if(d>elapse) then
          tinsert(waitTable,i,{d-elapse,f,p})
          i = i + 1
        else
          count = count - 1
          f(unpack(p))
        end
      end
    end)
  end
  tinsert(waitTable,{delay,func,{...}})
  return true
end

function TorghastHelper.checkTooltipForDuplicates()
    for i=1,GameTooltip:NumLines() do
        local tooltip=_G["GameTooltipTextLeft"..i]
        local tt = tooltip:GetText()
        if tt ~= nil and string.find(tt, TAG) ~= nil then
            return false
        end
    end
    return true
end

function TorghastHelper.scanForItems()
	isRSoulPresent = false
	isInfuserPresent = false
	for container=0,4 do
		local c = GetContainerNumSlots(container)
		for slot=1,c do
			local _, _, _, quality, _, _, _, _, _, itemID = GetContainerItemInfo(container, slot)			
			if itemID == 170540 then --ranveonous anima soul
				isRSoulPresent = true
				soulLocation = {["container"] = container, ["slot"] = slot}
			end
			if itemID == 184652 then -- phantasmic infuser
				isInfuserPresent = true
				infuserLocation = {["container"] = container, ["slot"] = slot}
			end
			if isRSoulPresent and isInfuserPresent then
				return
			end
		end
	end
end

function TorghastHelper.loadSV()
	alwaysDisplayTraits = AlwaysDisplayAnimaPowers
	if alwaysDisplayTraits == nil then
		alwaysDisplayTraits = false
	end
	showBuffName = svShowBuffName
	if showBuffName == nil then
		showBuffName = true
	end
	showDescription = svShowDescription
	if showDescription == nil then
		showDescription = false
	end
end

function TorghastHelper.saveSV()
	AlwaysDisplayAnimaPowers = alwaysDisplayTraits
	svShowDescription = showDescription
	svShowBuffName = showBuffName
end
