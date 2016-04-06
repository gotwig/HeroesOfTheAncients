-- This is the primary barebones gamemode script and should be used to assist in initializing your game mode


require ('libraries/notifications')

matchstarttexts = {'Fight, kill!','Let the battle begin!','Now go, and summon my golems!'}


-- Set this to true if you want to see a complete debug output of all events/processes done by barebones
-- You can also change the cvar 'barebones_spew' at any time to 1 or 0 for output/no output
BAREBONES_DEBUG_SPEW = false 

if GameMode == nil then
    DebugPrint( '[BAREBONES] creating barebones game mode' )
    _G.GameMode = class({})
end



-- This library allow for easily delayed/timed actions
require('libraries/timers')
-- This library can be used for advancted physics/motion/collision of units.  See PhysicsReadme.txt for more information.
require('libraries/physics')
-- This library can be used for advanced 3D projectile systems.
require('libraries/projectiles')
-- This library can be used for sending panorama notifications to the UIs of players/teams/everyone
require('libraries/notifications')
-- This library can be used for starting customized animations on units from lua
require('libraries/animations')
-- This library can be used for performing "Frankenstein" attachments on units
require('libraries/attachments')


-- These internal libraries set up barebones's events and processes.  Feel free to inspect them/change them if you need to.
require('internal/gamemode')
require('internal/events')

-- settings.lua is where you can specify many different properties for your game mode and is one of the core barebones files.
require('settings')

-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core barebones files.
require('events')

--[[
  This function should be used to set up Async precache calls at the beginning of the gameplay.

  In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
  after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
  be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
  precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
  defined on the unit.

  This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
  time, you can call the functions individually (for example if you want to precache units in a new wave of
  holdout).

  This function should generally only be used if the Precache() function in addon_game_mode.lua is not working.
]]
function GameMode:PostLoadPrecache()
  DebugPrint("[BAREBONES] Performing Post-Load precache")    
  --PrecacheItemByNameAsync("item_example_item", function(...) end)
  --PrecacheItemByNameAsync("example_ability", function(...) end)

  --PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
  --PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)
  	LinkLuaModifier( "modifier_bush_hiding_lua", "modifiers/modifier_bush_hiding.lua", LUA_MODIFIER_MOTION_NONE ) 

end

--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode:OnFirstPlayerLoaded()
  DebugPrint("[BAREBONES] First Player has loaded")
	
	GameRules.koboldEntitiesPositions = {}
	GameRules.skullGolemPosition = nil

	local counter = 0

	for key,value in pairs(Entities:FindAllByModel("models/creeps/neutral_creeps/n_creep_kobold/kobold_c/n_creep_kobold_c.vmdl"))
	do
		counter =  counter + 1
		GameRules.koboldEntitiesPositions[counter] = value:GetAbsOrigin()
	end
	
	
	GameRules.skullGolemPosition = Entities:FindByModel(nil,"models/creeps/neutral_creeps/n_creep_golem_a/neutral_creep_golem_a.vmdl"):GetAbsOrigin()
	
	initCamp(1,2,20)
	initCamp(2,4,20)
	initCamp(3,2,20)
	
	initTowers(2)
	

end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function GameMode:OnAllPlayersLoaded()
  numPlayerAmount = PlayerResource:GetPlayerCountForTeam(0) + PlayerResource:GetPlayerCountForTeam(1)
  DebugPrint("[BAREBONES] All Players have loaded into the game")
end

--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.

  The hero parameter is the hero entity that just spawned in
]]
function GameMode:OnHeroInGame(hero)

  Convars:SetBool("dota_hide_cursor", true)
  

  Convars:SetInt("dota_minimap_hero_size", 1100)
  Convars:SetInt("dota_minimap_creep_scale", 1)
  Convars:SetFloat("dota_enemy_color_r", 0.70)
  Convars:SetFloat("dota_enemy_color_g", 0.00)
  Convars:SetFloat("dota_enemy_color_b", 0.04)
  Convars:SetFloat("dota_neutral_color_r", 0.71)
  Convars:SetFloat("dota_neutral_color_g", 0.59)
  Convars:SetFloat("dota_neutral_color_b", 0.10)
  Convars:SetFloat("dota_friendly_color_r ", 0.16)
  Convars:SetFloat("dota_friendly_color_g", 0.26)
  Convars:SetFloat("dota_friendly_color_b", 0.77)
  Convars:SetInt("dota_minimap_always_draw_hero_icons", 1)

  

  DebugPrint("[BAREBONES] Hero spawned in game for first time -- " .. hero:GetUnitName())

  -- This line for example will set the starting gold of every hero to 0 unreliable gold
  hero:SetGold(0, false)

  	for playerID = 0, DOTA_MAX_TEAM_PLAYERS do 

	local player = PlayerResource:GetPlayer(playerID)

		if (PlayerResource:IsValidPlayerID(playerID) and player:GetTeamNumber() == hero:GetTeamNumber()) then  

			if (hero:GetPlayerID() ~= playerID)
			then
				for i = 1,PlayerResource:GetLevel(playerID)-1 do
					hero:HeroLevelUp(false)
				end
				hero:AddExperience(PlayerResource:GetSelectedHeroEntity(playerID):GetCurrentXP(), 0, false, false)
				return false
			end

		end 

	end  
  
  -- These lines will create an item and add it to the player, effectively ensuring they start with the item
  --local item = CreateItem("item_example_item", hero, hero)
  --hero:AddItem(item)

  --[[ --These lines if uncommented will replace the W ability of any hero that loads into the game
    --with the "example_ability" ability

  local abil = hero:GetAbilityByIndex(1)
  hero:RemoveAbility(abil:GetAbilityName())
  hero:AddAbility("example_ability")]]
  
  hero:AddNewModifier(hero, nil, "modifier_bush_hiding", {duration=.5}) 

  
end

--[[
  This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
  gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
  is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]

function GameMode:OnGameInProgress()
  DebugPrint("[BAREBONES] The game has officially begun")
  
  Notifications:TopToAll({text=matchstarttexts[RandomInt( 1, #matchstarttexts )], duration=10.0})


   teamselection = ""


   
	Timers:CreateTimer(function()
		
		for teamnumber = 2,3 do
			if (teamnumber == 2) then
				teamselection = "good"
				
				SpawnTop( teamselection , teamnumber, 1)
				SpawnBot( teamselection , teamnumber, 1)
				
				
				
			end
		
			if (teamnumber == 3) then
				teamselection = "bad"
				
				SpawnTop( teamselection , teamnumber, 1) 
				SpawnBot( teamselection , teamnumber, 1) 
							
			
			end
			
		end
		
		SpawnSiege()
		return 30.0
	end)
end

function SpawnTop( teamselection , teamnumber, position)
		if (Entities:FindByName( nil, "npc_dota_spawner_".. teamselection .. "_top_".. position .. ""))
		then
		
			for i = 1,3 do
			local rangedCreep = CreateUnitByName("npc_dota_necronomicon_archer_1_custom", Entities:FindByName( nil, "npc_dota_spawner_".. teamselection .. "_top_".. position .. ""):GetAbsOrigin(), true, nil, nil, teamnumber)
			local meleeCreep = CreateUnitByName("npc_dota_creep_".. teamselection .. "guys_melee", Entities:FindByName( nil, "npc_dota_spawner_".. teamselection .. "_top_".. position .. ""):GetAbsOrigin(), true, nil, nil, teamnumber)
			
			for i = 1,6 do
			
			ExecuteOrderFromTable({ UnitIndex = rangedCreep:entindex(), OrderType =  DOTA_UNIT_ORDER_ATTACK_MOVE, Position = Entities:FindByName( nil, "lane_top_pathcorner_" .. teamselection .. "guys_" .. i ):GetAbsOrigin(), Queue = true})
			ExecuteOrderFromTable({ UnitIndex = meleeCreep:entindex(), OrderType =  DOTA_UNIT_ORDER_ATTACK_MOVE , Position = Entities:FindByName( nil, "lane_top_pathcorner_".. teamselection .. "guys_" .. i ):GetAbsOrigin(),Queue = true})
		
			end
			
			end
			
			local rangedMageCreep = CreateUnitByName("npc_dota_creep_".. teamselection .. "guys_ranged", Entities:FindByName( nil, "npc_dota_spawner_".. teamselection .. "_top_".. position .. ""):GetAbsOrigin(), true, nil, nil, teamnumber)
			for i = 1,6 do
			ExecuteOrderFromTable({ UnitIndex = rangedMageCreep:entindex(), OrderType =  DOTA_UNIT_ORDER_ATTACK_MOVE, Position = Entities:FindByName( nil, "lane_top_pathcorner_" .. teamselection .. "guys_" .. i ):GetAbsOrigin(), Queue = true})
			end
		
		end
end

function SpawnBot( teamselection , teamnumber, position )
		if (Entities:FindByName( nil, "npc_dota_spawner_".. teamselection .. "_bot_".. position .. ""))
		then
			for i = 1,3 do

			local rangedCreep = CreateUnitByName("npc_dota_necronomicon_archer_1_custom", Entities:FindByName( nil, "npc_dota_spawner_".. teamselection .. "_bot_".. position .. ""):GetAbsOrigin(), true, nil, nil, teamnumber)
			local meleeCreep = CreateUnitByName("npc_dota_creep_".. teamselection .. "guys_melee", Entities:FindByName( nil, "npc_dota_spawner_".. teamselection .. "_bot_".. position .. ""):GetAbsOrigin(), true, nil, nil, teamnumber)
			
			for i = 1,4 do
				ExecuteOrderFromTable({ UnitIndex = rangedCreep:entindex(), OrderType =  DOTA_UNIT_ORDER_ATTACK_MOVE, Position = Entities:FindByName( nil, "lane_bot_pathcorner_" .. teamselection .. "guys_" .. i):GetAbsOrigin(), Queue = true})
				ExecuteOrderFromTable({ UnitIndex = meleeCreep:entindex(), OrderType =  DOTA_UNIT_ORDER_ATTACK_MOVE , Position = Entities:FindByName( nil, "lane_bot_pathcorner_".. teamselection .. "guys_" .. i):GetAbsOrigin(),Queue = true})
			end
			
			end
			
			local rangedMageCreep = CreateUnitByName("npc_dota_creep_".. teamselection .. "guys_ranged", Entities:FindByName( nil, "npc_dota_spawner_".. teamselection .. "_bot_".. position .. ""):GetAbsOrigin(), true, nil, nil, teamnumber)

			for i = 1,4 do
			ExecuteOrderFromTable({ UnitIndex = rangedMageCreep:entindex(), OrderType =  DOTA_UNIT_ORDER_ATTACK_MOVE, Position = Entities:FindByName( nil, "lane_bot_pathcorner_" .. teamselection .. "guys_" .. i):GetAbsOrigin(), Queue = true})
			end
			
		end

end

function SpawnSiege()
			if (GameRules.siegeTop['good'])
			then
			local siegeCreep = CreateUnitByName("npc_dota_goodguys_siege",		Entities:FindByName( nil, "npc_dota_spawner_good_top_1"):GetAbsOrigin(), true, nil, nil, 2)
			ExecuteOrderFromTable({ UnitIndex = siegeCreep:GetEntityIndex(), OrderType =  DOTA_UNIT_ORDER_ATTACK_MOVE , Position = Entities:FindByName( nil, "lane_top_pathcorner_goodguys_6"):GetAbsOrigin(),Queue = true})
			end
			
			if (GameRules.siegeTop['bad'])
			then
			local siegeCreep = CreateUnitByName("npc_dota_badguys_siege",		Entities:FindByName( nil, "npc_dota_spawner_bad_top_1"):GetAbsOrigin(), true, nil, nil, 3)
			ExecuteOrderFromTable({ UnitIndex = siegeCreep:GetEntityIndex(), OrderType =  DOTA_UNIT_ORDER_ATTACK_MOVE , Position = Entities:FindByName( nil, "lane_top_pathcorner_badguys_6"):GetAbsOrigin(),Queue = true})
			end
			
			if (GameRules.siegeBot['good'])
			then
			local siegeCreep = CreateUnitByName("npc_dota_goodguys_siege",		Entities:FindByName( nil, "npc_dota_spawner_good_bot_1"):GetAbsOrigin(), true, nil, nil, 2)
			ExecuteOrderFromTable({ UnitIndex = siegeCreep:GetEntityIndex(), OrderType =  DOTA_UNIT_ORDER_ATTACK_MOVE , Position = Entities:FindByName( nil, "lane_bot_pathcorner_goodguys_4"):GetAbsOrigin(),Queue = true})
			end
			
			if (GameRules.siegeBot['bad'])
			then
			local siegeCreep = CreateUnitByName("npc_dota_badguys_siege",		Entities:FindByName( nil, "npc_dota_spawner_bad_bot_1"):GetAbsOrigin(), true, nil, nil, 3)
			ExecuteOrderFromTable({ UnitIndex = siegeCreep:GetEntityIndex(), OrderType =  DOTA_UNIT_ORDER_ATTACK_MOVE , Position = Entities:FindByName( nil, "lane_bot_pathcorner_badguys_4"):GetAbsOrigin(),Queue = true})
			end

end

function GameMode:FilterXP( filterTable )
 
local actPlayer = PlayerResource:GetPlayer(filterTable.player_id_const)
 
local xp = filterTable.experience
 
	for playerID = 0, DOTA_MAX_TEAM_PLAYERS do 

	local player = PlayerResource:GetPlayer(playerID)

		if PlayerResource:IsValidPlayerID(playerID) and player:GetTeamNumber() == actPlayer:GetTeamNumber() then 

			local teamplayers = PlayerResource:GetPlayerCountForTeam(actPlayer:GetTeamNumber())

			PlayerResource:GetSelectedHeroEntity(playerID):AddExperience(math.floor(xp/teamplayers),
																		filterTable.reason_const,
																		false,
																		false)

		end 

	end

return false

end

function GameMode:FilterGold( filterTable )

return false

end

-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()

  Convars:SetBool("dota_hide_cursor", false);
  

  GameMode = self
  DebugPrint('[BAREBONES] Starting to load Barebones gamemode...')

  -- Call the internal function to set up the rules/behaviors specified in constants.lua
  -- This also sets up event hooks for all event handlers in events.lua
  -- Check out internals/gamemode to see/modify the exact code
  GameMode:_InitGameMode()
	
  --Communism ftw
  --All players share the same level ingame
  GameRules:GetGameModeEntity():SetModifyExperienceFilter( Dynamic_Wrap( GameMode, "FilterXP" ), self )
  
  -- Never heard of Gold. Everyones as poor as the other.
  GameRules:GetGameModeEntity():SetModifyGoldFilter( Dynamic_Wrap( GameMode, "FilterGold" ), self )

  -- Deactivate Day/Night Cycle
  GameRules:GetGameModeEntity():SetDaynightCycleDisabled(true) 
  
  -- Commands can be registered for debugging purposes or as functions that can be called by the custom Scaleform UI
  Convars:RegisterCommand( "command_example", Dynamic_Wrap(GameMode, 'ExampleConsoleCommand'), "A console command example", FCVAR_CHEAT )
  
  DebugPrint('[BAREBONES] Done loading Barebones gamemode!\n\n')
end

-- This is an example console command
function GameMode:ExampleConsoleCommand()
  print( '******* Example Console Command ***************' )
  local cmdPlayer = Convars:GetCommandClient()
  if cmdPlayer then
    local playerID = cmdPlayer:GetPlayerID()
    if playerID ~= nil and playerID ~= -1 then
      -- Do something here for the player who called this command
      PlayerResource:ReplaceHeroWith(playerID, "npc_dota_hero_viper", 1000, 1000)
    end
  end

  print( '*********************************************' )
  
  
  
end