local AddOnName, IKMEngine = ...

-- Author      : rek0
-- Create Date : 10/24/2019 11:00:38 PM
ImmortalKingsMod = LibStub("AceAddon-3.0"):GetAddon("ImmortalKingsMod")
ImmortalKingsMod_RaidMod = ImmortalKingsMod:NewModule("RaidMod", "AceEvent-3.0", "AceHook-3.0")

local f = CreateFrame("FRAME")

local function Check()
	if IKMDBMRM.State then
		ImmortalKingsMod_RaidMod:Enable()
		DEFAULT_CHAT_FRAME:AddMessage("|c00ff9d1eIK|c00ff0f4fM|c00ffffff - modul "..IKMDBMRM.Name.." geladen|r",0,0,1);
	else
		ImmortalKingsMod_RaidMod:Disable()
		DEFAULT_CHAT_FRAME:AddMessage("|c00ff9d1eIK|c00ff0f4fM|c00ffffff - modul "..IKMDBMRM.Name.." nicht aktiv|r",0,0,1);
	end
end

function ImmortalKingsMod_RaidMod:OnInitialize()
	Check()
end

function ImmortalKingsMod_RaidMod:OnEnable()
	f:RegisterEvent("CHAT_MSG_RAID")
	f:RegisterEvent("CHAT_MSG_YELL")
	f:RegisterEvent("CHAT_MSG_RAID_LEADER")
	f:RegisterEvent("CHAT_MSG_RAID_WARNING")
end

function ImmortalKingsMod_RaidMod:OnDisable()
	-- Disabling modules unregisters all events/hook automatically
	f:UnregisterEvent("CHAT_MSG_RAID")
	f:UnregisterEvent("CHAT_MSG_YELL")
	f:UnregisterEvent("CHAT_MSG_RAID_LEADER")
	f:UnregisterEvent("CHAT_MSG_RAID_WARNING")
end

function EventManager(self, event, ...)
	local _, eventType, _, sourceGUID, raidplayername, _, _, _, destName, _, _ = CombatLogGetCurrentEventInfo()	
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
    end
	if event == "CHAT_MSG_YELL" then
		if IKMDBMRM.AutoAhu then 
			if playerName == "Aach-Everlook" or playerName == "Aach" or playerName == "Brooly-Everlook" or playerName == "Brooly" then
				if text:match("B D K - Was ist euer Handwerk ????") then
					script=PlaySoundFile("Interface\\AddOns\\ImmortalKingsMod\\Sounds\\RaidMod\\RM.ogg", "Master", false)
					C_Timer.After(3, function() SendChatMessage("AHUU!!", "YELL") end)
				end
			end
		end
	end
end

f:SetScript("OnEvent", EventManager)