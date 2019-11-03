local AddOnName, IKMEngine = ...
IKMEngine[1] = { }

-- Erstelle das Addon
ImmortalKingsMod = LibStub("AceAddon-3.0"):NewAddon("ImmortalKingsMod", "AceConsole-3.0", "AceEvent-3.0" );
ImmortalKingsMod = ImmortalKingsMod

-- Module:
-- Module sind am anfang immer aus
ImmortalKingsMod:SetDefaultModuleState(false)

-- Prifile DB (self.db.profile.)
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
						DAMAGE_SHIELD = true,
						DAMAGE_SPLIT = true,
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
							SPELL_DAMAGE = 2,
							SPELL_HEAL = 3, 
							SPELL_PERIODIC_DAMAGE = 4,
							SPELL_PERIODIC_HEAL = 5, 
							DAMAGE_SPLIT = 6, 
							SPELL_EXTRA_ATTACKS = 7,
							DAMAGE_SHIELD = 8,
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
							"[CRITICAL SPELL]", 
							"[CRITICAL HEAL]", 
							"[CRITICAL DOT]", 
							"[CRITICAL HOT]", 
							"[CRITICAL SPLIT]", 
							"[CRITICAL FURY HIT]", 
							"[CRITICAL SHIELD HIT]",
						},
					},
				},
				-- self.db.profile.module.CritSound.SoundOutput
				SoundOutput = {
					State = true,
					Path = "Interface\\AddOns\\ImmortalKingsMod\\Sounds\\CritSounds\\",
					BM = {
						"Interface\\AddOns\\IKM\\Sounds\\CritSounds\\bam.ogg",
					},
					L2 = { 
						"Interface\\AddOns\\IKM\\Sounds\\CritSounds\\lineage.ogg",
						"Interface\\AddOns\\IKM\\Sounds\\CritSounds\\lineage2.ogg"
					},
					
				},	
			},
		},
	},
}

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


 

local playerID = UnitGUID("player");

function ImmortalKingsMod:OnInitialize()
		-- Print a message to the chat frame
		self:Print("IMMORTAL KING CORE LUA GELADEN 'OnInitialize' ImmortalKingsMod")
		self.db = LibStub("AceDB-3.0"):New("ImmortalKingsModDB", defaults, true)
		IKMDB = self.db.profile
		IKMDBMCS = self.db.profile.module.CritSound
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

-- Show the GUI if no input is supplied, otherwise handle the chat input.
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
        print("|c00ff9d1eImmortal Kings |c00ff0f4fMod|r - Help Menu");
        print("/ikm           (Open the IKM Options)");
        print("/ikm mo      (Module Menu)");
        print("/ikm cs       (CritSound Menu)");
        --print("/ikm rk       (SoundOutput Menu)");
        return;
    end

    -- /questie toggle
    if cmd[1] == "mo" and cmd[2] == "cs" then
		if cmd[3] == "on" then
			if not IKMDBMCS.State then
				IKMDBMCS.State = true;
				print("Das Modul CritSound wurde Aktiviert.")
			else
				print("Das Modul ist bereits Aktiv.")
			end
			return;
		elseif cmd[3] == "off" then
			if IKMDBMCS.State then
				IKMDBMCS.State = false;
				print("Das Modul CritSound wurde Deaktiviert.")
			else
				print("Das Modul ist bereits Deaktiviert.")
			end
			return;
		end
	elseif cmd[1] == "mo" and cmd[2] == "rk" then
		if cmd[3] == "on" then	
			if not IKMDBMRK.State then
				IKMDBMRK.State = true;
				print("Das Modul RaidBossKill wurde Aktiviert.")
			else
				print("Das Modul ist bereits Aktiv.")
			end
			return;
		elseif cmd[3] == "off" then
			if IKMDBMRK.State then
				IKMDBMRK.State = false;
				print("Das Modul RaidBossKill wurde Deaktiviert.")
			else
				print("Das Modul ist bereits Deaktiviert.")
			end
			return;
		end
	elseif cmd[1] == "mo" then
			print("|c00ff9d1eImmortal Kings |c00ff0f4fMod|r - Module Menue")
			print("/ikm mo cs <on/off>      (Für den CritSound):")
			print("/ikm mo rk <on/off>      (Für den RaidKillCheck):")
			return;
	end

	    -- /questie toggle
	  if cmd[1] == "cs" and cmd[2] == "co" and cmd[3] then
			IKMDBMCSCO_Window = cmd[3]	
			if  (_G["ChatFrame"..IKMDBMCSCO_Window]:IsVisible() == false) then
				local frame = FCF_DockFrame(_G["ChatFrame"..IKMDBMCSCO_Window], IKMDBMCSCO_Window)
			end		
	elseif cmd[1] == "cs" and cmd[2] == "co" then 
				for i = 1, 10 do
					tabb = i
					_G["ChatFrame"..tabb]:AddMessage("Gib das Chatfenster ein in dem die Crits angezeigt werden sollen.")
					_G["ChatFrame"..tabb]:AddMessage("Chatfenster: "..i)
				end		
	elseif cmd[1] == "cs" and cmd[2] == "so" and cmd[3] == "l2" then
			IKMDB.module.CritSound.SoundOutput.Mode = self.db.profile.module.CritSound.SoundOutput.L2
			print("SoundOutput - Lineage 2 CritSound ist nun Aktiv")
	elseif cmd[1] == "cs" and cmd[2] == "so" and cmd[3] == "bm" then
			IKMDB.module.CritSound.SoundOutput.Mode = self.db.profile.module.CritSound.SoundOutput.BM
			print("SoundOutput - BamMod CritSound ist nun Aktiv")
	elseif cmd[1] == "cs" and cmd[2] == "so" then
			print("|c00ff9d1eImmortal Kings |c00ff0f4fMod|r - CritSound SoundOutput Menue")
			print("/ikm cs so l2      (Für den Lineage2 CritSound):")
			print("/ikm cs so bm      (Für den BamMod CritSound):")
	elseif cmd[1] == "cs" then
			print("|c00ff9d1eImmortal Kings |c00ff0f4fMod|r - CritSound Menue")
			print("/ikm cs co       (Für den ChatOutput):")
			print("/ikm cs so       (Für den SoundOutput):")
			return;
	end
			
			
    if cmd[1] == "reload" then
         print(test7);
        return
    end

end



function _IKM(input)
  		tab = 1
		_G["ChatFrame"..tab]:AddMessage(input)
end


function ImmortalKingsMod:RegisterModul(nameofmodul, value)
	IKMEngine[nameofmodul] = value;
end


function ImmortalKingsMod:LoadModul()
	for k,v in pairs(IKMEngine) do 
		--print(k,v)
		Mname = k 
		if v == "enable" then
			print(Mname)
			Mname:Enable()
			print("ist aktiv")
		elseif v == "disable" then
			print(Mname)
			Mname:Enable()
			print("ist nicht aktiv")
		end
	end
end
