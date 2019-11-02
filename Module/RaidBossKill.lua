local AddOnName, WATEngine = ...

local WowAddonTestRBK_Bosse = {
"Botschafter Flammenschlag",
"Un'rel",
}

-- Author      : rek0
-- Create Date : 10/24/2019 11:00:38 PM

WowAddonTest = LibStub("AceAddon-3.0"):GetAddon("WowAddonTest")
WowAddonTest_RaidBossKill = WowAddonTest:NewModule("RaidBossKill", "AceEvent-3.0", "AceHook-3.0")
WowAddonTest_RaidBossKill.description = "Adds a Sound to each Crit."

function WowAddonTest_RaidBossKill:OnEnable()
	DEFAULT_CHAT_FRAME:AddMessage("|c00ff9d1eIK|c00ff0f4fM|c00ffffff- module RaidBossKill loaded|r",0,0,1);
end

function WowAddonTest_RaidBossKill:OnDisable()
	-- Disabling modules unregisters all events/hook automatically
end

function WowAddonTest_RaidBossKill:EventManager(self, event, ...)
print("event raidboss")
local _, eventType, _, sourceGUID, _, _, _, _, destName, _, _ = CombatLogGetCurrentEventInfo()	
	if eventType == "UNIT_DIED" then
		for _, value in pairs(WowAddonTestRBK_Bosse) do
			if value == destName then
				print("yo gefunden in value")
				WowAddonTest_RaidBossKill:RBK_Checker()
			end
		end
	end
end

function WowAddonTest_RaidBossKill:RBK_Checker()
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




WowAddonTest:RegisterModul(WowAddonTest_RaidBossKill, "enable")