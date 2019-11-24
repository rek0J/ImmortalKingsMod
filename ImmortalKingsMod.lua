local AddOnName, IKMEngine = ...
IKMEngine[1] = { }
IKMEngine[2] = { } -- Module
local ModulDB = IKMEngine[2]
local ModulDBCS = ModulDB[ImmortalKingsMod_CritSound]
-- Erstelle das Addon
ImmortalKingsMod = LibStub("AceAddon-3.0"):NewAddon("ImmortalKingsMod", "AceConsole-3.0", "AceEvent-3.0" );
ImmortalKingsMod = ImmortalKingsMod

-- Module:
-- Module sind am anfang immer aus
ImmortalKingsMod:SetDefaultModuleState(false)


local myOptions = {
  type = "group",
  args = {
    enable = {
      name = "Enable",
      desc = "Enables / disables the addon",
      type = "toggle",
      set = function(info,val) ImmortalKingsMod.enabled = val end,
      get = function(info) return ImmortalKingsMod.enabled end
    },
    CritSound = {
      name = "CritSound",
      type = "group",
      args = {
		enable = {
			name = "Enable",
			desc = "Enables / disables the addon",
			type = "toggle",
			set = function(info,val) ImmortalKingsMod.enabled = val end,
			get = function(info) return ImmortalKingsMod.enabled end
		},
        -- more options go here
      },
    }
  }
}

-- ImmortalKingsMod Datenbank (self.db)
local defaults = {
	-- self.db.profile
	profile = { 
		-- self.db.profile.module
		module ={
			-- self.db.profile.module.CritSound
			CritSound = {
				State = true,
				-- self.db.profile.module.CritSound.ChatOutput
				ChatOutput = {
					State = true,
					Mode = "SELF",
					-- self.db.profile.module.CritSound.ChatOutput.Events
					Events = {
						SWING_DAMAGE = true,
						RANGE_DAMAGE = true,
						SPELL_DAMAGE = true,
						SPELL_PERIODIC_DAMAGE = true,
						SPELL_EXTRA_ATTACKS = true,
						SPELL_HEAL = true,
						SPELL_PERIODIC_HEAL = true
					},
					-- self.db.profile.module.CritSound.ChatOutput.Type
					Type = { SELF , SAY , YELL , PARTY , GUILD ,RAID },
					-- self.db.profile.module.CritSound.ChatOutput.Msg
					Msg = { 
						-- self.db.profile.module.CritSound.ChatOutput.Msg.Type
						Type = {
							SWING_DAMAGE = 1, 
							RANGE_DAMAGE = 2, 
							SPELL_DAMAGE = 3,
							SPELL_HEAL = 4, 
							SPELL_PERIODIC_DAMAGE = 5,
							SPELL_PERIODIC_HEAL = 6, 
							SPELL_EXTRA_ATTACKS = 7,
						},
						-- self.db.profile.module.CritSound.ChatOutput.Msg.Color
						Color = { 
							"|C00ff0f4f",     
							"|C00ff0f4f",       
							"|C009aff35",      
							"|C00ff0f4f",     
							"|C009aff35",     
							"|C00ff0f4f",       
							"|C009aff35",          
							"|C009aff35",
						},
						-- self.db.profile.module.CritSound.ChatOutput.Msg.Text
						Text = { 
							"[CRITICAL HIT]",
							"[CRITICAL RANGE HIT]",
							"[CRITICAL SPELL]", 
							"[CRITICAL HEAL]", 
							"[CRITICAL DOT]", 
							"[CRITICAL HOT]", 
							"[CRITICAL FURY HIT]", 
						},
					},
				},
				-- self.db.profile.module.CritSound.SoundOutput
				SoundOutput = {
					State = true,
					Path = "Interface\\AddOns\\ImmortalKingsMod\\Sounds\\CritSounds\\",
					BM = {
						"Interface\\AddOns\\ImmortalKingsMod\\Sounds\\CritSounds\\bam.ogg",
					},
					L2 = { 
						"Interface\\AddOns\\ImmortalKingsMod\\Sounds\\CritSounds\\lineage.ogg",
						"Interface\\AddOns\\ImmortalKingsMod\\Sounds\\CritSounds\\lineage2.ogg"
					},
					
				},	
			},
		},
	},
}




 

local playerID = UnitGUID("player");


function ImmortalKingsMod:OnInitialize()
		-- Print a message to the chat frame
		print("|c00ff9d1eImmortal Kings |c00ff0f4fMod|r - Das AddOn wurde erfolgreich geladen.")
		self.db = LibStub("AceDB-3.0"):New("ImmortalKingsModDB", defaults, true)
		IKMDB = self.db.profile
		IKMDBMCS = self.db.profile.module.CritSound
		--IKMDBMRK = self.db.profile.module.CritSound
		IKMDB.module.CritSound.SoundOutput.Mode = self.db.profile.module.CritSound.SoundOutput.L2
		--local IKMDB = ImmortalKingsMod.Database
		--kann die function aus der db.lua laden
		--ImmortalKingsModDatabase:LoadDatabase()
		
		--ImmortalKingsModDatabase:Two()
		--print(ImmortalKingsMod.Database.profile.setting)
		--_IKM("HALLOOOO"..teste.."waaat |c00ff9d1eImmortal Kings |c00ff0f4fMod|r")
		-- TESTING
		
		LibStub("AceConfig-3.0"):RegisterOptionsTable("|c00ff9d1eImmortal Kings |c00ff0f4fMod|r - Options", myOptions);
		self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("|c00ff9d1eImmortal Kings |c00ff0f4fMod|r - Options", "|c00ff9d1eImmortal Kings |c00ff0f4fMod|r")

		-- Register events
		self:RegisterChatCommand("ikm", "ChatCommand")
		self:RegisterChatCommand("ImmortalKingsMod", "ChatCommand")

ImmortalKingsMod:LoadModul()
end

function ImmortalKingsMod:OnEnable()
		-- Called when the addon is enabled
		--print(teste)
		--print(IKMDB.ChatOutput)
		

end

function ImmortalKingsMod:OnDisable()
		-- Called when the addon is disabled
end


function ImmortalKingsMod:ChatCommand(input)
	local cmd = { }
	for c in string.gmatch(input, "[^ ]+") do
		table.insert(cmd, string.lower(c))
	end
    if not cmd[1] or cmd[1] == "" then
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    end

    -- /war help || /IKM ?
    if cmd[1] == "help" or cmd[1] == "?" then
        print("|c00ff9d1eImmortal Kings |c00ff0f4fMod|r - Hilfe Menue");
        print("/ikm               (Open the IKM Options)");
        print("/ikm mo          (Module Menue)");
		for n in pairs(ModulDB) do 
			for k,v in pairs(ModulDB[n]) do 
				if k == "State" and v == "enable" then
					print("/ikm "..ModulDB[n].Chat.. "       ("..ModulDB[n].NameS.." Menue):")	
				end
			end
		end
        return;
    end

    -- /ikm mo xx (module on/off)
	if cmd[1] == "mo" and cmd[2] then
		for n in pairs(ModulDB) do
			for k,v in pairs(ModulDB[n]) do 
				--print("key: "..k.." value: "..v)
				if k == "Chat" and v == cmd[2] then
					if cmd[3] == "on" then
						if ModulDB[n].State == "disable" then
							ModulDB[n].State = "enable";
							print("Das Modul "..ModulDB[n].NameS.." wurde Aktiviert.")
							print("ChatCommand: '/ikm "..v.."' wurde hinzugefügt.")
						else
							print("Das Modul "..ModulDB[n].NameS.." ist bereits Aktiv.")
						end
						return;
					elseif cmd[3] == "off" then
						if ModulDB[n].State == "enable" then
							ModulDB[n].State = "disable";
							print("Das Modul "..ModulDB[n].NameS.." wurde Deaktiviert.")
						else
							print("Das Modul "..ModulDB[n].NameS.." ist bereits Deaktiviert.")
						end
						return;
					else
						print("Das Modul "..ModulDB[n].NameS.." ist "..ModulDB[n].State)
					end
				end
			end
		end
	elseif cmd[1] == "mo" then
		print("|c00ff9d1eImmortal Kings |c00ff0f4fMod|r - Module Menue")
		for n in pairs(ModulDB) do
			for k,v in pairs(ModulDB[n]) do
				if k == "State" and v == "enable" then
					for k,v in pairs(ModulDB[n]) do
						if k == "Chat" then
							print("/ikm mo "..v.. " <on/off>         (Fuer den "..ModulDB[n].NameS.."):")
						end
					end
				end
			end
		end
	end
		
	-- /questie toggle
	for n in pairs(ModulDB) do 
		for k,v in pairs(ModulDB[n]) do 
			if k == "State" and v == "enable" then
				for k,v in pairs(ModulDB[n]) do
					if k == "Chat" and v == cmd[1] then
						if cmd[2] == "co" and cmd[3] == "ch" and cmd[4] then
							local name, _, _, _, _, _, _, _, _, _ = GetChatWindowInfo(cmd[4])
							if name and name == "" then
								print("Der Channel mit der Nummer "..cmd[4].." wurde nicht gefunden")
							else
								IKMDBMCSCO_Window = cmd[4]	
								if  (_G["ChatFrame"..IKMDBMCSCO_Window]:IsVisible() == false) then
									local frame = FCF_DockFrame(_G["ChatFrame"..IKMDBMCSCO_Window], IKMDBMCSCO_Window)
								end
								print("die Crits werden nun im Chatfenster: "..cmd[4].." ("..name..") angezeigt.")
								break
							end
						elseif cmd[2] == "co" and cmd[3] == "cf" then 
							for i = 1, 10 do
								local name, _, _, _, _, _, _, _, _, _ = GetChatWindowInfo(i)
								if name and name == "" then
									break	
								else
									_G["ChatFrame"..i]:AddMessage("Gib das Chatfenster ein in dem die Crits angezeigt werden sollen. (/ikm cs co ch <number>)")
									_G["ChatFrame"..i]:AddMessage("Chatfenster: "..i)
									if i == 10 then
										return
									end
								end	
							end
						elseif cmd[2] == "co" then
							print("|c00ff9d1eImmortal Kings |c00ff0f4fMod|r - CritSound ChatOuutput Menue")
							print("/ikm cs co cf      (lasse dir die Fensternummern anzeigen):")
							print("/ikm cs co ch      (im welchen fenster sollen die crits angezeigt werden):")
							return; 	
						elseif cmd[2] == "so" and cmd[3] == "l2" then
							IKMDB.module.CritSound.SoundOutput.Mode = self.db.profile.module.CritSound.SoundOutput.L2
							print("SoundOutput - Lineage 2 CritSound ist nun Aktiv")
						elseif cmd[2] == "so" and cmd[3] == "bm" then
							IKMDB.module.CritSound.SoundOutput.Mode = self.db.profile.module.CritSound.SoundOutput.BM
							print("SoundOutput - BamMod CritSound ist nun Aktiv")
						elseif cmd[2] == "so" and not cmd[3] then
							print("|c00ff9d1eImmortal Kings |c00ff0f4fMod|r - CritSound SoundOutput Menue")
							print("/ikm cs so l2      (Für den Lineage2 CritSound):")
							print("/ikm cs so bm      (Für den BamMod CritSound):")
							return;
						else
							print("|c00ff9d1eImmortal Kings |c00ff0f4fMod|r - CritSound Menue")
							print("/ikm cs co       (Für den ChatOutput):")
							print("/ikm cs so       (Für den SoundOutput):")
							return;
						end	
					end
				end
			else 
			end
		end
	end


 
	
end



function _IKM(input)
  		tab = 1
		_G["ChatFrame"..tab]:AddMessage(input)
end


function ImmortalKingsMod:RegisterModul(nameofmodul, value, chco, shortcut)
	ModulDB[nameofmodul] = {};
	ModulDB[nameofmodul].Name = nameofmodul;
	ModulDB[nameofmodul].State = value;
	ModulDB[nameofmodul].Chat = chco;
	ModulDB[nameofmodul].NameS = shortcut;
end


function ImmortalKingsMod:LoadModul()
	for n in pairs(ModulDB) do 
		local MName = n
		for k,v in pairs(ModulDB[n]) do 
			--print("key: "..k.." value: "..v)
			if k == "State" and v == "enable" then
				MName:Enable()
				DEFAULT_CHAT_FRAME:AddMessage("|c00ff9d1eIK|c00ff0f4fM|c00ffffff - modul "..ModulDB[n].NameS.." geladen|r",0,0,1);
			elseif k == "State" and v == "disable" then
				MName:Disable()
				DEFAULT_CHAT_FRAME:AddMessage("|c00ff9d1eIK|c00ff0f4fM|c00ffffff - modul "..ModulDB[n].NameS.." nicht aktiv|r",0,0,1);
			end
		end
	end
end
