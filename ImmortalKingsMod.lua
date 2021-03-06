local AddOnName, IKMEngine = ...

-- Erstelle das Addon
ImmortalKingsMod = LibStub("AceAddon-3.0"):NewAddon("ImmortalKingsMod", "AceConsole-3.0", "AceEvent-3.0" );
ImmortalKingsMod = ImmortalKingsMod

-- Module:
-- Module sind am anfang immer aus
--ImmortalKingsMod:SetDefaultModuleState(false)


local myOptions = {
	type = "group",
		args = {
			CritSound = {
				name = "CritSound",
				type = "group",
				args = {
					header = {
						name = "CritSound Einstellungen",
						type = "header",
						order = 0,
					},
					description = {
						name  = "Spielt einen Sound ab wenn ein Kritischer schlag getroffen wurde.",
						type = "description",
						order = 1,
					},
					enable = {
						name = "Aktiviert",
						desc = "Aktiviere/Deaktiviere die CritSound's",
						order = 2,
						type = "toggle",
						set = function(info,val) IKMDBMCS.State = val end,
						get = function(info) return IKMDBMCS.State end
					},
					chatoutput = {
						name = "Einstellungen f�r den Chat Output: ",
						type = "group",
						childGroups = "tab",
						inline = true,
						order = 3,
						args = {
							chatoutputwindow = {
								name = "In welchem fenster wollen die Crit's erscheinen? (NUR Als Console Output)",
								type = 'select',
								style = "radio",
								values = function() 
									chatwindowanzeige = { }
									for i = 1, 10 do
										local name, _, _, _, _, _, _, _, _, _ = GetChatWindowInfo(i)
										if name and name == "" then
											break	
										else
											if i ~= 2 then	
												chatwindowanzeige[i] = name
											end
										end
										if i == 10 then
											break
										end		
									end
									return chatwindowanzeige
								end,
								get = function(info)
									return IKMDBMCS.ChatOutput.Window
								end,
								set = function(info, key)			
										IKMDBMCS.ChatOutput.Window = key
										if (_G["ChatFrame"..IKMDBMCS.ChatOutput.Window]:IsVisible() == false) then
											local frame = FCF_DockFrame(_G["ChatFrame"..IKMDBMCS.ChatOutput.Window], IKMDBMCS.ChatOutput.Window)
										end
										local name, _, _, _, _, _, _, _, _, _ = GetChatWindowInfo(key)

										_G["ChatFrame"..IKMDBMCS.ChatOutput.Window]:AddMessage("Die Crits werden nun im Fenster "..key.." ("..name..") angezeigt.!!")
								end,
							},
							chatoutput = {
								order = 3,
								name = "Wie sollen die Crit's ausgegeben werden?",
								desc = "Aendert den zu hoerenden Crit Sound",
								type = 'select',
								style = "radio",
								values = function() 
									addoncritoutput = {
										["SELF"] = "Als Console Output",
										["SAY"] = "Im /s Chat (say)",
										["YELL"] = "Im /y Chat (yell)",
										["PARTY"] = "Im /p Chat (party)",
										["GUILD"] = "Im /g Chat (guild)",
										["RAID"] = "Im /ra Chat (raid)",
										["OFF"] = "Nirgends",
									}
									return addoncritoutput
								end,
								get = function(info)
									return IKMDBMCS.ChatOutput.Mode
								end,
								set = function(info, key)
									print(key)
									IKMDBMCS.ChatOutput.Mode = key
									if IKMDBMCS.ChatOutput.Mode == "SELF" then
										_G["ChatFrame"..IKMDBMCS.ChatOutput.Window]:AddMessage("Die Crits werden hier angezeigt!!")
									elseif IKMDBMCS.ChatOutput.Mode == "OFF" then
										_G["ChatFrame"..IKMDBMCS.ChatOutput.Window]:AddMessage("Die Crits werden nicht mehr im Chat angezeigt.!!")
									else 
										_G["ChatFrame"..IKMDBMCS.ChatOutput.Window]:AddMessage("Die Crits werden nun im "..key.." Chat angezeigt.!!")
									end
								end,
							},
						},
					},
					soundoutput = {
						name = "Einstellungen f�r den Sound Output: ",
						type = "group",
						inline = true,
						order = 3,
						args = {
							select = {
								order = 3,
								name = "Waehle den Sound aus.",
								desc = "Aendert den zu hoerenden Crit Sound",
								type = 'select',
								style = "radio",
								values = function() 
									addoncritsounds = {
										["BM"] = "BamMod Sound",
										["L2"] = "Lineage 2 Crit",
										["HS"] = "Homer DOH Sound",
										["OFF"] = "Aus",
									}
									return addoncritsounds
								end,
								set = function(info, key)
									IKMDBMCS.SoundOutput.Mode = key
									CritSoundMode2 = IKMDBMCS.SoundOutput.Sounds[IKMDBMCS.SoundOutput.Mode]
									script=PlaySoundFile(CritSoundMode2[math.random(1, table.getn(CritSoundMode2))], "Dialog");
								end,
								get = function(info) return IKMDBMCS.SoundOutput.Mode end
							},
							toasty = {
								name = "Toasty Sound",
								desc = "Aktivieren/Deaktivieren",
								order = 5,
								type = "toggle",
								set = function(info,val) IKMDBMCS.SoundOutput.Toast = val end,
								get = function(info) return IKMDBMCS.SoundOutput.Toast end
							},
							toastydmg = {
								name = "Toasty Sound",
								desc = "Aktivieren/Deaktivieren",
								order = 5,
								type = "range",
								min =1, max = 5000, step = 1,
								set = function(info,val) IKMDBMCS.SoundOutput.ToastDMG = val end,
								get = function(info) return IKMDBMCS.SoundOutput.ToastDMG end
							},
						},
					},
				},
			},
			--RaidMod Settings
			RaidMod = {
				name = "RaidMod",
				type = "group",
				args = {
					header = {
						name = "RaidMod Einstellungen",
						type = "header",
						order = 0,
					},
					description = {
						name  = "Diese Modul wurde f�r die Gilde Immortal Kings geschrieben",
						type = "description",
						order = 1,
					},
					enable = {
						name = "Aktiviert",
						desc = "Aktiviere/Deaktiviere den RaidMod",
						type = "toggle",
						order = 2,
						set = function(info,val) IKMDBMRM.State = val end,
						get = function(info) return IKMDBMRM.State end
					},
					Tabs = {
						name = "Funktionen: ",
						type = "group",
						inline = true,
						order = 3,
						args = {
							autoahu = {
								name = "Auto Send AHUU",
								desc = "schreib automatisch AHUU wenn Aach das zeichen daf�r gibt",
								type = "toggle",
								order = 1,
								set = function(info,val) IKMDBMRM.AutoAhu = val end,
								get = function(info) return IKMDBMRM.AutoAhu end
							},
							streammode = {
								name = "Verstecke Sprechblasen",
								desc = "zeigt NUR das AHUU an",
								type = "toggle",
								order = 3,
								set = function(info,val) IKMDBMRM.StreamMode = val; if IKMDBMRM.StreamMode then IKMDBMRM.StreamModeBubble = 1 else IKMDBMRM.StreamModeBubble = 0 end end,
								get = function(info) return IKMDBMRM.StreamMode end
							},
							ahukevinmode = {
								name = "AHU KEVIN MODE :D",
								desc = "gibt 3x \"AHUU!\" wieder",
								type = "toggle",
								order = 2,
								set = function(info,val) IKMDBMRM.AhuKevinMode = val end,
								get = function(info) return IKMDBMRM.AhuKevinMode end
							},
						},
					},
				},
			},
		},
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
					Command = "co",
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
						SPELL_PERIODIC_HEAL = true,
						SWING_EXTRA_ATTACKS = true
					},
					-- self.db.profile.module.CritSound.ChatOutput.Type
					Type = { 
						SELF = true,
						SAY = true,
						YELL = true,
						PARTY = true,
						GUILD = true,
						RAID = true,
						OFF	= true,
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
							"|C000b9822",	--GR�N	(SPELL_HEAL)  
							"|C00dd0066",	--IWAS	(SPELL_PERIODIC_DAMAGE)
							"|C00a1d30d",	--GR�N	(SPELL_PERIODIC_HEAL) 
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
					Command = "so",
					Mode = BM,
					Sounds = {
						OFF = { "" },
						BM = { "Interface\\AddOns\\ImmortalKingsMod\\Sounds\\CritSounds\\bam.ogg" },
						HS = { "Interface\\AddOns\\ImmortalKingsMod\\Sounds\\CritSounds\\doh.ogg" },
						L2 = { "Interface\\AddOns\\ImmortalKingsMod\\Sounds\\CritSounds\\lineage.ogg", 
							   "Interface\\AddOns\\ImmortalKingsMod\\Sounds\\CritSounds\\lineage2.ogg",
						},
					},
					Toast = true,
					ToastDMG = 3000,
					ToastSound = "Interface\\AddOns\\ImmortalKingsMod\\Sounds\\CritSounds\\toasty.ogg",
				},
					
			},
			RaidMod = {
				State = true,
				Name = "Raid Mod",
				Command = "rm",
				AutoAhu = true,
				AhuKevinMode = false,
				StreamMode = false,
				StreamModeBubble = 1,
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
					print("ChatCommand: '/ikm "..IKMDBM[n].Command.."' wurde hinzugef�gt.")
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
		if cmd[1] == "cs" and cmd[2] == "co" and cmd[3] == "ch" and cmd[4] then
			local name, _, _, _, _, _, _, _, _, _ = GetChatWindowInfo(cmd[4])
			if name and name == "" then
				print("Der Channel mit der Nummer "..cmd[4].." wurde nicht gefunden")
			else
				IKMDBMCS.ChatOutput.Window = cmd[4]	
				if  (_G["ChatFrame"..IKMDBMCS.ChatOutput.Window]:IsVisible() == false) then
					local frame = FCF_DockFrame(_G["ChatFrame"..IKMDBMCS.ChatOutput.Window], IKMDBMCS.ChatOutput.Window)
				end
				print("die Crits werden nun im Chatfenster: "..cmd[4].." ("..name..") angezeigt.")
			end
		elseif cmd[1] == "cs" and cmd[2] == "co" and cmd[3] == "cf" then 
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
		elseif cmd[1] == "cs" and cmd[2] == "co" and cmd[3] == "ty" and cmd[4] then
			_G["ChatFrame5"]:AddMessage(string.upper(cmd[4]))
			for t in pairs(IKMDBMCS.ChatOutput.Type) do
				if cmd[4] == string.lower(t) then
					IKMDBMCS.ChatOutput.Mode = string.upper(cmd[4])
					_G["ChatFrame5"]:AddMessage("Chat Output = "..cmd[4])
				end
			end
		elseif cmd[1] == "cs" and cmd[2] == "co" and cmd[3] == "ty" and not cmd[4] then
			print("|c00ff9d1eImmortal Kings |c00ff0f4fMod|r - CritSound ChatOutput Type")
			print("/ikm cs co ty      (self, say, party, guild, raid, yell):")
		elseif cmd[1] == "cs" and cmd[2] == "co" then
			print("|c00ff9d1eImmortal Kings |c00ff0f4fMod|r - CritSound ChatOutput Menue")
			print("/ikm cs co cf      (lasse dir die Fensternummern anzeigen):")
			print("/ikm cs co ch      (im welchen fenster sollen die crits angezeigt werden):")
			return; 	
		elseif cmd[1] == "cs" and cmd[2] == "so" and cmd[3] then
			for m, _ in pairs(IKMDBMCS.SoundOutput.Sounds) do
				if string.lower(m) == cmd[3] then
					IKMDBMCS.SoundOutput.Mode = string.upper(cmd[3])
					CritSoundMode = IKMDBMCS.SoundOutput.Sounds[IKMDBMCS.SoundOutput.Mode]
					print("|c00ff9d1eImmortal Kings |c00ff0f4fMod|r - CritSound SoundOutput Menue")
					_G["ChatFrame1"]:AddMessage("Sound Output = "..cmd[3])
					_G["ChatFrame1"]:AddMessage(IKMDBMCS.SoundOutput.Mode)
					script=PlaySoundFile(CritSoundMode[math.random(1, table.getn(CritSoundMode))], "Dialog");
				end
			end
		elseif cmd[1] == "cs" and cmd[2] == "so" and not cmd[3] then
			print("|c00ff9d1eImmortal Kings |c00ff0f4fMod|r - CritSound SoundOutput Menue")
			_G["ChatFrame1"]:AddMessage("Sound Output = "..IKMDBMCS.SoundOutput.Mode)
			return;
		elseif cmd[1] == "cs" and not cmd[2] then
			print("|c00ff9d1eImmortal Kings |c00ff0f4fMod|r - CritSound Menue")
			print("/ikm cs co")
			print("/ikm cs so")
			return;
		end	
	end




function _IKM(input)
		_G["ChatFrame1"]:AddMessage(input)
end
