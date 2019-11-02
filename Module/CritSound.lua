local AddOnName, WATEngine = ...

-- Author      : rek0
-- Create Date : 10/24/2019 11:00:38 PM

WowAddonTest = LibStub("AceAddon-3.0"):GetAddon("WowAddonTest")
WowAddonTest_CritSound = WowAddonTest:NewModule("CritSound", "AceEvent-3.0", "AceHook-3.0")
WowAddonTest_CritSound.description = "Adds a Sound to each Crit."

-- Um das addon von anfang an zu starten
--if WATDBMCS.State then
--	WowAddonTest_CritSound:Enable()
--	print("aktiv")
--else
--	print("not aktiv")
--end
-- eine ifabfrage erstellen um das modul via optionen ein und aus zu schalten


	local playerGUID, petGUID, new_petGUID, link, critAmount, InterfaceOptions_AddCategory, InterfaceOptionsFrame_OpenToCategory 
	= playerGUID, petGUID, new_petGUID, link, critAmount, InterfaceOptions_AddCategory, InterfaceOptionsFrame_OpenToCategory	
	
local UnitGUID = UnitGUID
local playerID = UnitGUID("player")
local tab = 1


function WowAddonTest_CritSound:OnEnable()
		print("modul critsound aktiviert123")
		WowAddonTestFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		WowAddonTestFrame:RegisterEvent("UNIT_PET", "player")
		--DEFAULT_CHAT_FRAME:AddMessage("|c00ff9d1eIK|c00ff0f4fM|c00ffffff- module CritSound loaded|r",0,0,1);
		if WATDBMCSCO_Mode == nil then
			WATDBMCSCO_Mode = "SELF"
		end
		if WATDBMCSSO_Mode == nil then
			WATDBMCSSO_Mode = L2
		end
end

function WowAddonTest_CritSound:OnDisable()
	-- Disabling modules unregisters all events/hook automatically

end

function WowAddonTest_CritSound:EventManager(self, event, ...)
print("event critsound")
local _, eventType, _, sourceGUID, _, _, _, _, destName, _, _ = CombatLogGetCurrentEventInfo()
	if sourceGUID == playerID then
		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			if not WATDBMCS.ChatOutput.Events[eventType] then
				return
			else	
				WowAddonTest_CritSound:CRIT_Checker()
			end
		elseif event == "UNIT_PET" then
			local petID = UnitGUID("pet")		
		end
	end
end

function WowAddonTest_CritSound:CRIT_Checker2()
		local timestamp, combatEvent, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags =  CombatLogGetCurrentEventInfo(); -- Those arguments appear for all combat event variants.
		local eventPrefix, eventSuffix = combatEvent:match("^(.-)_?([^_]*)$");
		if eventPrefix == "RANGE" or eventPrefix:match("^SPELL") then
				if eventSuffix == "DAMAGE" or eventSuffix == "PERIODIC_DAMAGE" then
					-- The first three arguments after destFlags in ... describe the spell or ability dealing damage.
					-- Extract this data using select as well:
						local spellId, spellName, spellSchool = select(9, CombatLogGetCurrentEventInfo()); -- Everything from 9th argument in ... onward
					-- Do something with the spell details ...
				elseif eventSuffix == "HEAL" or eventSuffix == "PERIODIC_HEAL" then
						local _, spellName, _, amount, _, _, critical = select(12, CombatLogGetCurrentEventInfo())
				end			
		elseif eventPrefix == "SWING" then
					-- Something dealt damage. The last 9 arguments in ... describe how it was dealt.
					-- To extract those, we can use the select function:
						tab = 1
						_G["ChatFrame"..tab]:AddMessage("|c00ff9d1eIK|c00ff0f4fM|r - SWING ("..eventPrefix.."_"..eventSuffix..")");
						local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = select(select("#", CombatLogGetCurrentEventInfo())-8, CombatLogGetCurrentEventInfo()); -- select("#", ...) returns number of arguments in the vararg expression
					-- Do something with the damage details ... 	
		end
		tab = 1
		print("critical: "..critical.." amount: "..amount);
						
		if critical and amount >= 1 then
			
			_G["ChatFrame"..tab]:AddMessage("|c00ff9d1eIK|c00ff0f4fM|r - CRIT ERKANNT ");
						
				if IKM_CritSound.DB.OutputSetting == "SELF" then
						_G["ChatFrame"..tab]:AddMessage(hoh1[hoh0[eventType]]..hoh2[hoh0[eventType]]..hoh3[2]..spellName.." - |CFFFFFF01"..amount.."|r")
				else
						SendChatMessage(hoh2[hoh0[eventType]]..hoh3[1]..spellName.." - "..amount, IKM_CritSound.DB.OutputSetting ,nil);
				end
		end	

end

function WowAddonTest_CritSound:CRIT_Checker()
	local _, eventType, _, sourceGUID, _, _, _, _, destName, _, _ = CombatLogGetCurrentEventInfo()
	
	if (eventType == "RANGE_DAMAGE") or (eventType == "SPELL_DAMAGE") or (eventType == "SPELL_PERIODIC_DAMAGE") then
		_, spellName, _, amount, _, _, _, _, _, critical, _, _ = select(12, CombatLogGetCurrentEventInfo())
	elseif (eventType == "SWING_DAMAGE") then
		amount, _, _, _, _, _, critical, _, _, isOffHand = select(12, CombatLogGetCurrentEventInfo())
		if isOffHand == true then spellName = "MELEE (OH)" else	spellName = "MELEE (MH)" end
	elseif (eventType == "SPELL_HEAL") or (eventType == "SPELL_PERIODIC_HEAL") then
		_, spellName, _, amount, _, _, critical = select(12, CombatLogGetCurrentEventInfo())
	end
	if critical then
		if amount >= 1 then
			if WATDBMCS.ChatOutput.State and WATDBMCS.ChatOutput.Events[eventType] then
				if WATDBMCSCO_Mode == "SELF" then
					_G["ChatFrame"..tab]:AddMessage(WATDBMCS.ChatOutput.Msg.Color[WATDBMCS.ChatOutput.Msg.Type[eventType]]..WATDBMCS.ChatOutput.Msg.Text[WATDBMCS.ChatOutput.Msg.Type[eventType]].."|r - "..spellName.." - |CFFFFFF01"..amount.."|r")
				else
					SendChatMessage(WATDBMCS.ChatOutput.Msg.Text[WATDBMCS.ChatOutput.Msg.Type[eventType]].." - "..spellName.." - "..amount, WATDBMCSCO_Mode ,nil);
				end	
			end
			if WATDBMCS.SoundOutput.State then
				script=PlaySoundFile(WATDB.module.CritSound.ChatOutput.Mode[math.random(1, table.getn(WATDB.module.CritSound.ChatOutput.Mode))], "Dialog");
			end
		end
	end
end


WowAddonTest:RegisterModul(WowAddonTest_CritSound, "enable")