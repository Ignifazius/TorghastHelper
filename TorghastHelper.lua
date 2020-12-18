--[[
	TorghastHelper is a simple World of Warcraft addon.
    Copyright (C) 2020 Ignifazius

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]
TorghastHelper = {}
local TAG = "TH"
local name, addon = ...;
local _, L = ...;
local isRSoulPresent = false;

local eventResponseFrame = CreateFrame("Frame", "Helper")
    eventResponseFrame:RegisterEvent("ADDON_LOADED");
	eventResponseFrame:RegisterEvent("PLAYER_LOGIN")
	eventResponseFrame:RegisterEvent("PLAYER_LOGOUT")
	eventResponseFrame:RegisterEvent("ZONE_CHANGED")
	eventResponseFrame:RegisterEvent("ZONE_CHANGED_INDOORS")
	eventResponseFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	eventResponseFrame:RegisterEvent("BAG_UPDATE");

function TorghastHelper.registerAddon()
	eventResponseFrame:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
	eventResponseFrame:RegisterEvent("CURSOR_UPDATE");
end

function TorghastHelper.unregisterAddon()
	eventResponseFrame:UnregisterEvent("UPDATE_MOUSEOVER_UNIT");
	eventResponseFrame:UnregisterEvent("CURSOR_UPDATE");
end



function TorghastHelper.toggleAddon() 
	if TorghastHelper.isInTorghast() then
		TorghastHelper.registerAddon()
	else 
		TorghastHelper.unregisterAddon()
	end
end

function TorghastHelper.isInTorghast()
	local id = C_Map.GetBestMapForUnit("player");
	local mapinfo = C_Map.GetMapInfo(id);
	mapid = mapinfo.mapID;
	name = mapinfo.name;
	typ = mapinfo.mapType;
	parent = mapinfo.parentMapID;
	flags = mapinfo.flags;
	if name == "Torghast" then
		return true
	end
	return false
end


local function eventHandler(self, event, arg1, arg2, arg3, arg4, arg5)
    if (event == "UPDATE_MOUSEOVER_UNIT") then
        TorghastHelper.function__wait(0.1, TorghastHelper.addValueToTooltip)
    elseif (event == "CURSOR_UPDATE") then
        TorghastHelper.function__wait(0.1, TorghastHelper.addValueToTooltip)
    elseif(event == "ADDON_LOADED" and arg1 == "TorghastHelper") then
        if (GetLocale() ~= "deDE" and GetLocale() ~= "enGB" and GetLocale() ~= "enUS") then
            print("TorghastHelper: Your language is currently NOT fully supported. This addon will only work partially! Please consider providing some translations via the projects website: https://wow.curseforge.com/projects/TorghastHelper")
        end
	elseif(event == "PLAYER_LOGIN") then
		--TorghastHelper.createMenuFrame()
		TorghastHelper.toggleAddon()	
	elseif (event == "BAG_UPDATE") then
		TorghastHelper_scanForRSoul()
	if event == "ZONE_CHANGED_NEW_AREA" then --entering/leaving torghast
		TorghastHelper.toggleAddon()
	end
end
eventResponseFrame:SetScript("OnEvent", eventHandler);

function TorghastHelper.createMenuFrame()
	TorghastHelper.createConfigFrame()
	configFrame.name = "Torghast Helper";
	configFrame.refresh = TorghastHelper.refresh();
	InterfaceOptions_AddCategory(configFrame)
end


function TorghastHelper.addValueToTooltip()
	if isRSoulPresent then
		local coloredKey = GameTooltipTextLeft1:GetText()
		if (coloredKey ~= nil) then
			local key = string.gsub(coloredKey, "|cff%x%x%x%x%x%x", "")
			key = string.gsub(key, "|r", "")
			if key ~= nil then
				local infoText, prefix
				if addon.values[key] ~= nil and addon.values[key]["effect"] ~= nil and addon.values[key]["effect"]["description"] ~= nil then
					infoText = addon.values[key]["effect"]["description"]
					prefix = TAG..": "
				end
				if infoText ~= nil and TorghastHelper.checkTooltipForDuplicates() then
					GameTooltip:AddLine(prefix..infoText, 0.9, 0.8, 0.5, 1, 0)
					GameTooltip:Show()
				end
			end
		end
	end
end

function TorghastHelper.createConfigFrame()
	configTitle = configFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    configTitle:SetPoint("TOPLEFT", 16, -16)
    configTitle:SetText("Island Expedition Helper")
	
	configSpam = TorghastHelper.createCheckbox(
    	L["Disable Azerite Spam"],
    	L["Hide all Azerite related collection messages from the chat."],
    	function(self, value) TorghastHelper.DisplaySpam(value) end)
    configSpam:SetPoint("TOPLEFT", configTitle, "BOTTOMLEFT", 0, -8)
	
	configBottom = configFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    configBottom:SetPoint("BOTTOMLEFT", 16, 16)
    --configBottom:SetText("If you want to help to translate this addon, visit\n TODO \nor write me a PM on CurseForge. \nCurrently only German and English translations are available.")
end

local waitTable = {};
local waitFrame = nil;

function TorghastHelper.function__wait(delay, func, ...)
  if(type(delay)~="number" or type(func)~="function") then
    return false;
  end
  if(waitFrame == nil) then
    waitFrame = CreateFrame("Frame","WaitFrame", UIParent);
    waitFrame:SetScript("onUpdate",function (self,elapse)
      local count = #waitTable;
      local i = 1;
      while(i<=count) do
        local waitRecord = tremove(waitTable,i);
        local d = tremove(waitRecord,1);
        local f = tremove(waitRecord,1);
        local p = tremove(waitRecord,1);
        if(d>elapse) then
          tinsert(waitTable,i,{d-elapse,f,p});
          i = i + 1;
        else
          count = count - 1;
          f(unpack(p));
        end
      end
    end);
  end
  tinsert(waitTable,{delay,func,{...}});
  return true;
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



function TorghastHelper_scanForRSoul()
	for container=0,5 do
		for slot=0,34 do
			local _, _, _, quality, _, _, _, _, _, itemID = GetContainerItemInfo(container, slot)			
			if itemID == 170540 then --ranveonous anima soul
				isRSoulPresent = true
				return
			end
		end
	end
	isRSoulPresent = false
end