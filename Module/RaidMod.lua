local AddOnName, IKMEngine = ...
IKMEngine[1] = { }
IKMEngine[2] = { } -- Module
local ModulDB = IKMEngine[2]
local ModulDBRM = ModulDB[ImmortalKingsMod_CritSound]

local RaidChatCommandUser = { 
"Aach",
"Nahemo",
'Brooly',
'Brooly-Everlook',
"Tjured",
}

local RaidChatCommand = {
"test",
"ruhe",
"meins",
}

-- Author      : rek0
-- Create Date : 10/24/2019 11:00:38 PM

ImmortalKingsMod = LibStub("AceAddon-3.0"):GetAddon("ImmortalKingsMod")
ImmortalKingsMod_RaidMod = ImmortalKingsMod:NewModule("RaidMod", "AceEvent-3.0", "AceHook-3.0")
ImmortalKingsMod_RaidMod.description = "Adds a Sound to each Crit."
local f = CreateFrame("FRAME")

function ImmortalKingsMod_RaidMod:OnEnable()
	f:RegisterEvent("CHAT_MSG_RAID")
	f:RegisterEvent("CHAT_MSG_RAID_LEADER")
	f:RegisterEvent("CHAT_MSG_RAID_WARNING")
	f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED") 
end

function ImmortalKingsMod_RaidMod:OnDisable()
	-- Disabling modules unregisters all events/hook automatically
	f:UnregisterEvent("CHAT_MSG_RAID")
	f:UnregisterEvent("CHAT_MSG_RAID_LEADER")
	f:UnregisterEvent("CHAT_MSG_RAID_WARNING")
	f:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function EventManager(self, event, ...)
local _, eventType, _, sourceGUID, raidplayername, _, _, _, destName, _, _ = CombatLogGetCurrentEventInfo()	
	if eventType == "UNIT_DIED" then
		for _, value in pairs(ImmortalKingsModRM_Bosse) do
			if value == destName then
				ImmortalKingsMod_RaidMod:RM_Checker()
			end
		end
	end
    local text, playerName,_,_,_,_,_,_,_ = ...
    --if event == "CHAT_MSG_RAID" or event == "CHAT_MSG_RAID_LEADER" or event == "CHAT_MSG_RAID_WARNING" then
	if event == "CHAT_MSG_RAID_LEADER" or event == "CHAT_MSG_RAID_WARNING" then
--		if playerName == "Aach-Everlook" or playerName == "Aach" then
		--if playerName == "Gremnag-Everlook" or playerName == "Gremnag" then
			if text == "300" then
				script=PlaySoundFile("Interface\\AddOns\\ImmortalKingsMod\\Sounds\\RaidMod\\RM.ogg", "Master", false)
			elseif text == "meins" then
				script=PlaySoundFile("Interface\\AddOns\\ImmortalKingsMod\\Sounds\\RaidMod\\meins.ogg", "Master", false)
			elseif text == "test" then
				print("test")
			end
		--end


    end
end

f:SetScript("OnEvent", EventManager)

function ImmortalKingsMod_RaidMod:RM_Checker()
	local _, eventType, _, sourceGUID, _, _, _, _, destName, _, _ = CombatLogGetCurrentEventInfo()
			script=PlaySoundFile("Interface\\AddOns\\IK\\Sounds\\RaidSounds\\test.ogg", "Dialog")
			if IsInRaid() then
			print("yo3")
				SendChatMessage("RAIDCHAT: "..destName.." ist gefallen !", "RAID" ,nil);	
				SendChatMessage("RAID WARNING: "..destName.." ist gefallen !", "RAID_WARNING" ,nil);	
			elseif IsInGroup() then
			print("y4")
				SendChatMessage("PARTYCHAT: "..destName.." ist gefallen SAGT ALLE HACKI HACKI HACKI !", "PARTY" ,nil);	
			else 
				DEFAULT_CHAT_FRAME:AddMessage("|c00ff9d1eIK|c00ff0f4fM|c00ffffff- SELF: "..destName.." ist gefallen !",0,0,1);
			end
				
  -- local _, subevent, _, sourceName, _, _, destName, _, prefixParam1, prefixParam2, _, suffixParam1, suffixParam2 = CombatLogGetCurrentEventInfo()
 

end

local function Check()
	if not ModulDB[self] or ModulDBRM.State == "enable"  then
		ImmortalKingsMod:RegisterModul(ImmortalKingsMod_RaidMod, "enable", "rm", "RaidMod")
	elseif ModulDBRM.State == "disable" then
		ImmortalKingsMod:RegisterModul(ImmortalKingsMod_RaidMod, "disable", "rm", "RaidMod")
	end
end




Check()