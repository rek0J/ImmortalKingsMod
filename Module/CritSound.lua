local AddOnName, IKMEngine = ...
IKMEngine[1] = { }
IKMEngine[2] = { } -- Module
local ModulDB = IKMEngine[2]
local ModulDBCS = ModulDB[ImmortalKingsMod_CritSound]
-- Author      : rek0
-- Create Date : 10/24/2019 11:00:38 PM

ImmortalKingsMod = LibStub("AceAddon-3.0"):GetAddon("ImmortalKingsMod")
ImmortalKingsMod_CritSound = ImmortalKingsMod:NewModule("CritSound", "AceEvent-3.0", "AceHook-3.0")
ImmortalKingsMod_CritSound.description = "Adds a Sound to each Crit."

-- Um das addon von anfang an zu starten
--if IKMDBMCS.State then
--	ImmortalKingsMod_CritSound:Enable()
--	print("aktiv")
--else
--	print("not aktiv")
--end
-- eine ifabfrage erstellen um das modul via optionen ein und aus zu schalten


	local playerGUID, petGUID, new_petGUID, link, critAmount, InterfaceOptions_AddCategory, InterfaceOptionsFrame_OpenToCategory 
	= playerGUID, petGUID, new_petGUID, link, critAmount, InterfaceOptions_AddCategory, InterfaceOptionsFrame_OpenToCategory	
	
local UnitGUID = UnitGUID
local playerID = UnitGUID("player")


function ImmortalKingsMod_CritSound:OnEnable()
		--ImmortalKingsXMLFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		
		--ImmortalKingsXMLFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		--DEFAULT_CHAT_FRAME:AddMessage("|c00ff9d1eIK|c00ff0f4fM|c00ffffff- module CritSound loaded|r",0,0,1);
		if IKMDBMCSCO_Mode == nil then
			IKMDBMCSCO_Mode = "SELF"
		end
		if IKMDBMCSSO_Mode == nil then
			IKMDBMCSSO_Mode = L2
		end
		if IKMDBMCSCO_Window == nil then
			IKMDBMCSCO_Window = 1
		end
end

function ImmortalKingsMod_CritSound:OnDisable()
	-- Disabling modules unregisters all events/hook automatically

end

function ImmortalKingsMod_CritSound:CRIT_Checker2()
		local timestamp, eventType, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags =  CombatLogGetCurrentEventInfo(); -- Those arguments appear for all combat event variants.
		local eventPrefix, eventSuffix = eventType:match("^(.-)_?([^_]*)$");
		if eventPrefix == "RANGE" or eventPrefix:match("^SPELL") then
				if eventSuffix == "DAMAGE" or eventSuffix == "PERIODIC_DAMAGE" then
					-- The first three arguments after destFlags in ... describe the spell or ability dealing damage.
					-- Extract this data using select as well:
						--spellId, spellName, spellSchool = select(9, CombatLogGetCurrentEventInfo()); -- Everything from 9th argument in ... onward
						_, spellName, _, amount, _, _, _, _, _, critical, _, _ = select(12, CombatLogGetCurrentEventInfo())
					-- Do something with the spell details ...
				elseif eventSuffix == "HEAL" or eventSuffix == "PERIODIC_HEAL" then
						_, spellName, _, amount, _, _, critical = select(12, CombatLogGetCurrentEventInfo())
				end			
		elseif eventPrefix == "SWING" then
					-- Something dealt damage. The last 9 arguments in ... describe how it was dealt.
					-- To extract those, we can use the select function:
						--_G["ChatFrame"..IKMDBMCSCO_Window]:AddMessage("|c00ff9d1eIK|c00ff0f4fM|r - SWING ("..eventPrefix.."_"..eventSuffix..")");
						--amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = select(select("#", CombatLogGetCurrentEventInfo())-8, CombatLogGetCurrentEventInfo()); -- select("#", ...) returns number of arguments in the vararg expression
						amount, _, _, _, _, _, critical, _, _, isOffHand = select(12, CombatLogGetCurrentEventInfo())
						if isOffHand == true then spellName = "MELEE (OH)" else	spellName = "MELEE (MH)" end
					-- Do something with the damage details ... 	
		end
						
		if critical and amount >= 1 then
			
			--_G["ChatFrame"..IKMDBMCSCO_Window]:AddMessage("|c00ff9d1eIK|c00ff0f4fM|r - CRIT ERKANNT ");
						
				if IKMDBMCSCO_Mode == "SELF" then
					_G["ChatFrame"..IKMDBMCSCO_Window]:AddMessage(IKMDBMCS.ChatOutput.Msg.Color[IKMDBMCS.ChatOutput.Msg.Type[eventType]]..IKMDBMCS.ChatOutput.Msg.Text[IKMDBMCS.ChatOutput.Msg.Type[eventType]].."|r - "..spellName.." - |CFFFFFF01"..amount.."|r")
				else
					print("test2")
					SendChatMessage(IKMDBMCS.ChatOutput.Msg.Text[IKMDBMCS.ChatOutput.Msg.Type[eventType]].." - "..spellName.." - "..amount, IKMDBMCSCO_Mode ,nil);
				end

				if IKMDBMCS.SoundOutput.State then
					script=PlaySoundFile(IKMDB.module.CritSound.SoundOutput.Mode[math.random(1, table.getn(IKMDB.module.CritSound.SoundOutput.Mode))], "Dialog");
				end
		end	

end

function ImmortalKingsMod_CritSound:CRIT_Checker()
	local _, eventType, _, sourceGUID, _, _, _, _, destName, _, _ = CombatLogGetCurrentEventInfo()
	
	if IKMDBMCS.ChatOutput.Events[eventType] then
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
				if IKMDBMCS.ChatOutput.State then
					if IKMDBMCSCO_Mode == "SELF" then
						_G["ChatFrame"..IKMDBMCSCO_Window]:AddMessage(IKMDBMCS.ChatOutput.Msg.Color[IKMDBMCS.ChatOutput.Msg.Type[eventType]]..IKMDBMCS.ChatOutput.Msg.Text[IKMDBMCS.ChatOutput.Msg.Type[eventType]].."|r - "..spellName.." - |CFFFFFF01"..amount.."|r")
					else
						SendChatMessage(IKMDBMCS.ChatOutput.Msg.Text[IKMDBMCS.ChatOutput.Msg.Type[eventType]].." - "..spellName.." - "..amount, IKMDBMCSCO_Mode ,nil);
					end	
				end
				if IKMDBMCS.SoundOutput.State then
					script=PlaySoundFile(IKMDB.module.CritSound.SoundOutput.Mode[math.random(1, table.getn(IKMDB.module.CritSound.SoundOutput.Mode))], "Dialog");
				end
			end
		else
			return
		end
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:SetScript("OnEvent", function(self, event)
	local _, eventType, _, sourceGUID, _, _, _, _, destName, _, _ = CombatLogGetCurrentEventInfo()
	if sourceGUID == playerID then
		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			if not IKMDBMCS.ChatOutput.Events[eventType] then
				return
			else	
				ImmortalKingsMod_CritSound:CRIT_Checker2()
			end	
		end
	end
end)

local function Check()
	if not ModulDB[self] or ModulDBCS.State == "enable"  then
		ImmortalKingsMod:RegisterModul(ImmortalKingsMod_CritSound, "disable", "cs", "CritSound")
	elseif ModulDBCS.State == "disable" then
		ImmortalKingsMod:RegisterModul(ImmortalKingsMod_CritSound, "disable", "cs", "CritSound")
	end
end


Check()