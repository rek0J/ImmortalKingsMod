local AddOnName, IKMEngine = ...

-- Author      : rek0
-- Create Date : 10/24/2019 11:00:38 PM
ImmortalKingsMod = LibStub("AceAddon-3.0"):GetAddon("ImmortalKingsMod")
ImmortalKingsMod_CritSound = ImmortalKingsMod:NewModule("CritSound", "AceEvent-3.0", "AceHook-3.0")
local f = CreateFrame("Frame")
	
	local playerGUID, petGUID, new_petGUID, link, critAmount, InterfaceOptions_AddCategory, InterfaceOptionsFrame_OpenToCategory 
	= playerGUID, petGUID, new_petGUID, link, critAmount, InterfaceOptions_AddCategory, InterfaceOptionsFrame_OpenToCategory	
	
local UnitGUID = UnitGUID
local playerID = UnitGUID("player")




local function Check()
	if IKMDBMCS.State then
		ImmortalKingsMod_CritSound:Enable()
		DEFAULT_CHAT_FRAME:AddMessage("|c00ff9d1eIK|c00ff0f4fM|c00ffffff - modul "..IKMDBMCS.Name.." geladen|r",0,0,1);
	else
		ImmortalKingsMod_CritSound:Disable()
		DEFAULT_CHAT_FRAME:AddMessage("|c00ff9d1eIK|c00ff0f4fM|c00ffffff - modul "..IKMDBMCS.Name.." nicht aktiv|r",0,0,1);
	end
end

function ImmortalKingsMod_CritSound:OnInitialize()
	
	
	Check()
end

function ImmortalKingsMod_CritSound:OnEnable()
	f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function ImmortalKingsMod_CritSound:OnDisable()
	f:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED") 
end

function ImmortalKingsMod_CritSound:CRIT_Checker2()
		local timestamp, eventType, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags =  CombatLogGetCurrentEventInfo(); -- Those arguments appear for all combat event variants.
		local eventPrefix, eventSuffix = eventType:match("^(.-)_?([^_]*)$");
		if eventPrefix == "RANGE" or eventPrefix == "SPELL" or eventPrefix == "SPELL_PERIODIC" then
				if eventSuffix == "DAMAGE" then
					-- The first three arguments after destFlags in ... describe the spell or ability dealing damage.
					-- Extract this data using select as well:
						--spellId, spellName, spellSchool = select(9, CombatLogGetCurrentEventInfo()); -- Everything from 9th argument in ... onward
						_, spellName, _, amount, _, _, _, _, _, critical, _, _ = select(12, CombatLogGetCurrentEventInfo())
					-- Do something with the spell details ...
				elseif eventSuffix == "HEAL" then
						_, spellName, _, amount, _, _, critical = select(12, CombatLogGetCurrentEventInfo())
				end			
		elseif eventPrefix == "SWING" then
				amount, _, _, _, _, _, critical, _, _, isOffHand = select(12, CombatLogGetCurrentEventInfo())
				if isOffHand == true then spellName = "MELEE (OH)" else	spellName = "MELEE (MH)" end	
		end
						
		if critical and amount >= 1 then
			--_G["ChatFrame"..IKMDBMCSCO_Window]:AddMessage("|c00ff9d1eIK|c00ff0f4fM|r - CRIT ERKANNT ");
						
				if IKMDBMCS.ChatOutput.Mode == "SELF" or IKMDBMCS.ChatOutput.Mode == "self" then
					_G["ChatFrame"..IKMDBMCS.ChatOutput.Window]:AddMessage(IKMDBMCS.ChatOutput.Msg.Color[IKMDBMCS.ChatOutput.Msg.Type[eventType]]..IKMDBMCS.ChatOutput.Msg.Text[IKMDBMCS.ChatOutput.Msg.Type[eventType]].."|r - "..spellName.." - |CFFFFFF01"..amount.."|r")
				elseif not IKMDBMCS.ChatOutput.Mode == "OFF" then
					SendChatMessage(IKMDBMCS.ChatOutput.Msg.Text[IKMDBMCS.ChatOutput.Msg.Type[eventType]].." - "..spellName.." - "..amount, IKMDBMCS.ChatOutput.Mode ,nil);
				end

				if IKMDBMCS.SoundOutput.State then
					CritSoundMode = IKMDBMCS.SoundOutput.Sounds[IKMDBMCS.SoundOutput.Mode]
					script=PlaySoundFile(CritSoundMode[math.random(1, table.getn(CritSoundMode))], "Dialog");
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
					elseif IKMDBMCSCO_Mode == "OFF" then
						return
					else
						SendChatMessage(IKMDBMCS.ChatOutput.Msg.Text[IKMDBMCS.ChatOutput.Msg.Type[eventType]].." - "..spellName.." - "..amount, IKMDBMCSCO_Mode ,nil);
					end	
				end
				if IKMDBMCS.SoundOutput.State then
					script=PlaySoundFile(IKMDB.module.CritSound.SoundOutput[IKMDB.module.CritSound.SoundOutput.Mode][math.random(1, table.getn(IKMDB.module.CritSound.SoundOutput[IKMDB.module.CritSound.SoundOutput.Mode]))], "Dialog");
				end
			end
		else
			return
		end
	end
end


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




