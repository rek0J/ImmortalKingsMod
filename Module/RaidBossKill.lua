local AddOnName, IKMEngine = ...
IKMEngine[1] = { }
IKMEngine[2] = { } -- Module
local ModulDB = IKMEngine[2]
local ModulDBRB = ModulDB[ImmortalKingsMod_RaidBossKill]

local ImmortalKingsModRBK_Bosse = {
"Botschafter Flammenschlag",
"Un'rel",
}

-- Author      : rek0
-- Create Date : 10/24/2019 11:00:38 PM

ImmortalKingsMod = LibStub("AceAddon-3.0"):GetAddon("ImmortalKingsMod")
ImmortalKingsMod_RaidBossKill = ImmortalKingsMod:NewModule("RaidBossKill", "AceEvent-3.0", "AceHook-3.0")
ImmortalKingsMod_RaidBossKill.description = "Adds a Sound to each Crit."

function ImmortalKingsMod_RaidBossKill:OnEnable()
end

function ImmortalKingsMod_RaidBossKill:OnDisable()
	-- Disabling modules unregisters all events/hook automatically
end

function ImmortalKingsMod_RaidBossKill:EventManager(self, event, ...)
local _, eventType, _, sourceGUID, _, _, _, _, destName, _, _ = CombatLogGetCurrentEventInfo()	
	if eventType == "UNIT_DIED" then
		for _, value in pairs(ImmortalKingsModRBK_Bosse) do
			if value == destName then
				print("yo gefunden in value")
				ImmortalKingsMod_RaidBossKill:RBK_Checker()
			end
		end
	end
end

function ImmortalKingsMod_RaidBossKill:RBK_Checker()
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
	if not ModulDB[self] or ModulDBCS.State == "enable"  then
		ImmortalKingsMod:RegisterModul(ImmortalKingsMod_RaidBossKill, "disable", "rb", "RaidBossKill")
	elseif ModulDBCS.State == "disable" then
		ImmortalKingsMod:RegisterModul(ImmortalKingsMod_RaidBossKill, "disable", "rb", "RaidBossKill")
	end
end


Check()

