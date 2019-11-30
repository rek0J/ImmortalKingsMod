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
--ImmortalKingsMod:SetDefaultModuleState(false)


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
				Name = "Crit Sound",
				Command = "cs",
				-- self.db.profile.module.CritSound.ChatOutput
				ChatOutput = {
					State = true,
					Window = 1, 
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
					Type = { 
						SELF = true,
						SAY = true,
						YELL = true,
						PARTY = true,
						GUILD = true,
						RAID = true,
					},
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
							SWING_EXTRA_ATTACKS = 8,
						},
						-- self.db.profile.module.CritSound.ChatOutput.Msg.Color
						Color = { 
							"|C00ff0f4f",	--ROT	(SWING_DAMAGE)    
							"|C00ff0f4f",	--Rot	(RANGE_DAMAGE)
							"|C0063b8d4",	--BLAU	(SPELL_DAMAGE) 
							"|C000b9822",	--GRÜN	(SPELL_HEAL)  
							"|C00dd0066",	--IWAS	(SPELL_PERIODIC_DAMAGE)
							"|C00a1d30d",	--GRÜN	(SPELL_PERIODIC_HEAL) 
							"|C00f0b03f",	--GOLD	(SPELL_EXTRA_ATTACKS) 
							"|C00f0b03f",	--GOLD	(SWING_EXTRA_ATTACKS) 

						},
						-- self.db.profile.module.CritSound.ChatOutput.Msg.Text
						Text = { 
							"[CRITICAL SWING HIT]",
							"[CRITICAL RANGE HIT]",
							"[CRITICAL SPELL]", 
							"[CRITICAL HEAL]", 
							"[CRITICAL DOT]", 
							"[CRITICAL HOT]", 
							"[CRITICAL SPELL FURY HIT]", 
							"[CRITICAL SWING FURY HIT]", 
						},
					},
				},
				-- self.db.profile.module.CritSound.SoundOutput
				SoundOutput = {
					State = true,
					Mode = BM,
					Sounds = {
						OFF = { "" },
						BM = { "Interface\\AddOns\\ImmortalKingsMod\\Sounds\\CritSounds\\bam.ogg" },
						L2 = { "Interface\\AddOns\\ImmortalKingsMod\\Sounds\\CritSounds\\lineage.ogg", 
							   "Interface\\AddOns\\ImmortalKingsMod\\Sounds\\CritSounds\\lineage2.ogg",
						},
					},
				},	
			},
			RaidMod = {
				State = true,
				Name = "Raid Mod",
				Command = "rm",
			},
		},
	},
}




 

local playerID = UnitGUID("player");


function ImmortalKingsMod:OnInitialize()
		-- Print a message to the chat frame
		_IKM("|c00ff9d1eImmortal Kings |c00ff0f4fMod|r - Das AddOn wurde erfolgreich geladen.")

		self.db = LibStub("AceDB-3.0"):New("ImmortalKingsModDB", defaults, true)
		IKMDB = self.db.profile
		IKMDBM = self.db.profile.module
		IKMDBMCS = self.db.profile.module.CritSound
		IKMDBMRM = self.db.profile.module.RaidMod
		--_IKM("HALLOOOO"..teste.."waaat |c00ff9d1eImmortal Kings |c00ff0f4fMod|r")

		LibStub("AceConfig-3.0"):RegisterOptionsTable("|c00ff9d1eImmortal Kings |c00ff0f4fMod|r - Options", myOptions);
		self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("|c00ff9d1eImmortal Kings |c00ff0f4fMod|r - Options", "|c00ff9d1eImmortal Kings |c00ff0f4fMod|r")

		-- Register events
		self:RegisterChatCommand("ikm", "ChatCommand")
		self:RegisterChatCommand("ImmortalKingsMod", "ChatCommand")
end

function ImmortalKingsMod:OnEnable()
		-- Called when the addon is enabled
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
		for n in pairs(IKMDBM) do
			if cmd[2] == IKMDBM[n].Command and cmd[3] == "on" then
				if not IKMDBM[n].State then
					IKMDBM[n].State = true;
					print("Das Modul "..IKMDBM[n].Name.." wurde Aktiviert.")
					print("ChatCommand: '/ikm "..IKMDBM[n].Command.."' wurde hinzugefügt.")
					ReloadUI()
				else
					print("Das Modul "..IKMDBM[n].Name.." ist bereits Aktiv.")
				end
			elseif cmd[2] == IKMDBM[n].Command and cmd[3] == "off" then
				if IKMDBM[n].State then
					IKMDBM[n].State = false;
					print("Das Modul "..IKMDBM[n].Name.." wurde Deaktiviert.")
					ReloadUI()
				else
					print("Das Modul "..IKMDBM[n].Name.." ist bereits Deaktiviert.")
				end
			elseif cmd[2] == IKMDBM[n].Command then
				if IKMDBM[n].State then
					ikmmodulstate = "Aktiviert"
				else
					ikmmodulstate = "Deaktiviert"
				end
				print("Das Modul "..IKMDBM[n].Name.." ist "..ikmmodulstate)
			end
		end
	elseif cmd[1] == "mo" then
		print("|c00ff9d1eImmortal Kings |c00ff0f4fMod|r - Module Menue")
		for n in pairs(IKMDBM) do
			print("/ikm mo "..IKMDBM[n].Command.. " <on/off>         (Fuer den "..IKMDBM[n].Name.."):")
		end
	end
		
	-- /questie toggle
	for n in pairs(IKMDBM) do
		if cmd[2] == IKMDBM[n].Command and cmd[3] == "ch" and cmd[4] then
			local name, _, _, _, _, _, _, _, _, _ = GetChatWindowInfo(cmd[4])
			if name and name == "" then
				print("Der Channel mit der Nummer "..cmd[4].." wurde nicht gefunden")
			else
				IKMDBMCS.ChatOutput.Window = cmd[4]	
				if  (_G["ChatFrame"..IKMDBMCS.ChatOutput.Window]:IsVisible() == false) then
					local frame = FCF_DockFrame(_G["ChatFrame"..IKMDBMCS.ChatOutput.Window], IKMDBMCS.ChatOutput.Window)
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
		elseif cmd[2] == "co" and cmd[3] == "ty" and cmd[4] then
			_G["ChatFrame5"]:AddMessage(string.upper(cmd[4]))
			for t in pairs(IKMDBMCS.ChatOutput.Type) do
				if cmd[4] == string.lower(t) then
					IKMDBMCS.ChatOutput.Mode = string.upper(cmd[4])
					_G["ChatFrame5"]:AddMessage("Chat Output = "..cmd[4])
				end
			end
		elseif cmd[2] == "co" and cmd[3] == "ty" and not cmd[4] then
			print("|c00ff9d1eImmortal Kings |c00ff0f4fMod|r - CritSound ChatOutput Type")
			print("/ikm cs co ty      (self, say, party, guild, raid, yell):")
		elseif cmd[2] == "co" then
			print("|c00ff9d1eImmortal Kings |c00ff0f4fMod|r - CritSound ChatOutput Menue")
			print("/ikm cs co cf      (lasse dir die Fensternummern anzeigen):")
			print("/ikm cs co ch      (im welchen fenster sollen die crits angezeigt werden):")
			return; 	
		elseif cmd[2] == "so" and cmd[3] then
			for t in pairs(IKMDBMCS.SoundOutput.Sounds) do
				if cmd[3] == string.lower(t) then
					IKMDBMCS.SoundOutput.Mode = string.upper(cmd[3])
					CritSoundMode = IKMDBMCS.SoundOutput.Sounds[IKMDBMCS.SoundOutput.Mode]
					_G["ChatFrame1"]:AddMessage("Sound Output = "..cmd[3])
					_G["ChatFrame1"]:AddMessage(IKMDBMCS.SoundOutput.Mode)
					script=PlaySoundFile(CritSoundMode[math.random(1, table.getn(CritSoundMode))], "Dialog");
				end
			end
		elseif cmd[2] == "so" and not cmd[3] then
			print("|c00ff9d1eImmortal Kings |c00ff0f4fMod|r - CritSound SoundOutput Menue")
			print("/ikm cs so l2      (Für den Lineage2 CritSound):")
			print("/ikm cs so bm      (Für den BamMod CritSound):")
			print("/ikm cs so off     (Kein Sound):")
			return;
		else
			print("|c00ff9d1eImmortal Kings |c00ff0f4fMod|r - CritSound Menue")
			print("/ikm cs co       (Für den ChatOutput):")
			print("/ikm cs so       (Für den SoundOutput):")
			return;
		end	
	end


 
	
end

function _IKM(input)
		_G["ChatFrame1"]:AddMessage(input)
end
