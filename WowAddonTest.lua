local AddOnName, WATEngine = ...
WATEngine[1] = { }

-- Erstelle das Addon
WowAddonTest = LibStub("AceAddon-3.0"):NewAddon("WowAddonTest", "AceConsole-3.0", "AceEvent-3.0" );
WowAddonTest = WowAddonTest

-- Module:
-- Module sind am anfang immer aus
WowAddonTest:SetDefaultModuleState(false)

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
					Path = "Interface\\AddOns\\WowAddonTest\\Sounds\\CritSounds\\",
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
      set = function(info,val) WowAddonTest.enabled = val end,
      get = function(info) return WowAddonTest.enabled end
    },
    CritSound = {
      name = "CritSound",
      type = "group",
      args = {
		enable = {
		name = "Enable",
		desc = "Enables / disables the addon",
		type = "toggle",
		set = function(info,val) WowAddonTest.enabled = val end,
		get = function(info) return WowAddonTest.enabled end
    },
        -- more options go here
      },
    }
  }
}


 

local playerID = UnitGUID("player");
local tab = 1;

function WowAddonTest:OnInitialize()
		-- Print a message to the chat frame
		self:Print("IMMORTAL KING CORE LUA GELADEN 'OnInitialize' WOWADDONTEST")
		self.db = LibStub("AceDB-3.0"):New("WowAddonTestDB", defaults, true)
		--self.db = LibStub("AceDB-3.0"):New("WowAddonTest2DB", WATDBdefaults2, true)
		WATDB = self.db.profile
		WATDBMCS = self.db.profile.module.CritSound
		WATDB.module.CritSound.ChatOutput.Mode = self.db.profile.module.CritSound.SoundOutput.L2
		--local WATDB = WowAddonTest.Database
		--kann die function aus der db.lua laden
		--WowAddonTestDatabase:LoadDatabase()
		
		--WowAddonTestDatabase:Two()
		--print(WowAddonTest.Database.profile.setting)
		--_WAT("HALLOOOO"..teste.."waaat |c00ff9d1eImmortal Kings |c00ff0f4fMod|r")
		-- TESTING
		
		LibStub("AceConfig-3.0"):RegisterOptionsTable("WowAddonTestOPT", myOptions);
		--self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("|c00ff9d1eImmortal Kings |c00ff0f4fMod|r", "|c00ff9d1eImmortal Kings |c00ff0f4fMod|r")
		self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("WowAddonTestOPT", "WowAddonTestOPT2")

		-- Register events
		self:RegisterChatCommand("wat", "ChatCommand")
		self:RegisterChatCommand("wowaddontest", "ChatCommand")

WowAddonTest:LoadModul()
end

function WowAddonTest:OnEnable()
		-- Called when the addon is enabled
		--print(teste)
		--print(WATDB.ChatOutput)
		

end

function WowAddonTest:OnDisable()
		-- Called when the addon is disabled
end

-- Show the GUI if no input is supplied, otherwise handle the chat input.
function WowAddonTest:ChatCommand(input)
	local cmd = { }
	for c in string.gmatch(input, "[^ ]+") do
		table.insert(cmd, string.lower(c))
	end
    if not cmd[1] or cmd[1] == "" then
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    end

    -- /war help || /wat ?
    if cmd[1] == "help" or cmd[1] == "?" then
        print(test);
        print(test2);
        print(test3);
        print(test4);
        print(test5);
        return;
    end

    -- /questie toggle
    if cmd[1] == "mo" and cmd[2] == "on" then
			if not WATDBMCS.State then
				WATDBMCS.State = true;
				print("Das Modul CritSound wurde Aktiviert.")
			else
				print("Das Modul ist bereits Aktiv.")
			end
			return;
	elseif cmd[1] == "mo" and cmd[2] == "off" then
			if WATDBMCS.State then
				WATDBMCS.State = false;
				print("Das Modul CritSound ist nun Deaktiviert")
			else
				print("Das Modul ist bereits Deaktiviert.")
			end
			return;
	elseif cmd[1] == "mo" then
			print("WAT.Module - Menue")
			print("ist das modul CritSound aktiv?:"); print(WATDBMCS.State)
			return;
	end
			
			
    if cmd[1] == "reload" then
         print(test7);
        return
    end

end



function _WAT(input)
  		tab = 1
		_G["ChatFrame"..tab]:AddMessage(input)
end


function WowAddonTest:RegisterModul(nameofmodul, value)
	WATEngine[nameofmodul] = value;
end


function WowAddonTest:LoadModul()
	for k,v in pairs(WATEngine) do 
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
