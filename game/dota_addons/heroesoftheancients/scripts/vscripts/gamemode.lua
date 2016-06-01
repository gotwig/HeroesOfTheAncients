-- This is the primary barebones gamemode script and should be used to assist in initializing your game mode

-- This library can be used to synchronize client-server data via player/client-specific nettables
require('libraries/playertables')

require("towers")
require("worldpanels/worldpanelsInit")

require ('libraries/notifications')
require("libraries/worldpanels")

matchstarttexts = {'Fight, kill!','Let the battle begin!','Now go, and summon my golems!'}


function GetGridAroundPoint( numUnits, point )
    local navPoints = {}  

	local SQUARE_FACTOR = 0.4 --1 is a perfect square, higher numbers will increase the units per row
	
    local unitsPerRow = 3
    local unitsPerColumn = 2
    local remainder = numUnits - (unitsPerRow*unitsPerColumn) 

    local forward = point:Normalized()
    local right = RotatePosition(Vector(0,0,0), QAngle(0,90,0), forward)

    local start = (unitsPerColumn-1)* -.5

    local curX = start
    local curY = 0

    local offsetX = 100
    local offsetY = 100

    for i=1,unitsPerRow do
      for j=1,unitsPerColumn do
        local newPoint = point + (curX * offsetX * right) + (curY * offsetY * forward)
        navPoints[#navPoints+1] = newPoint
        curX = curX + 1
      end
      curX = start
      curY = curY - 1
    end

    local curX = ((remainder-1) * -.5)

    for i=1,remainder do 
        local newPoint = point + (curX * offsetX * right) + (curY * offsetY * forward)
        navPoints[#navPoints+1] = newPoint
        curX = curX + 1
    end

    return navPoints
end

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
	LinkLuaModifier("modifier_behindGate", "modifiers/modifier_behindGate", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_lowAttackPrio", "modifiers/modifier_lowAttackPrio", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_breaker_stun", "modifiers/modifier_breaker_stun", LUA_MODIFIER_MOTION_NONE)

end

--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode:OnFirstPlayerLoaded()
  DebugPrint("[BAREBONES] First Player has loaded")
	
	-- Play Sound countdown 10..1 
	Timers:CreateTimer(function()
	
	
		for playerID = 0, DOTA_DEFAULT_MAX_TEAM_PLAYERS	 do 

		local player = PlayerResource:GetPlayer(playerID)

			if (PlayerResource:IsValidPlayerID(playerID) and PlayerResource:GetSelectedHeroEntity(playerID)) then 

				if(math.floor(GameRules:GetDOTATime(false, true)) == -15 )
				then
					EmitAnnouncerSoundForPlayer("announcer_ann_custom_countdown_10", playerID)
				end
				
				if(math.floor(GameRules:GetDOTATime(false, true)) == -14 )
				then
					EmitAnnouncerSoundForPlayer("announcer_ann_custom_countdown_09", playerID)
				end
				
				if(math.floor(GameRules:GetDOTATime(false, true)) == -13 )
				then
					EmitAnnouncerSoundForPlayer("announcer_ann_custom_countdown_08", playerID)
				end
				
				if(math.floor(GameRules:GetDOTATime(false, true)) == -12 )
				then
					EmitAnnouncerSoundForPlayer("announcer_ann_custom_countdown_07", playerID)
				end
				
				if(math.floor(GameRules:GetDOTATime(false, true)) == -11 )
				then
					EmitAnnouncerSoundForPlayer("announcer_ann_custom_countdown_06", playerID)
				end
				
				if(math.floor(GameRules:GetDOTATime(false, true)) == -10 )
				then
					EmitAnnouncerSoundForPlayer("announcer_ann_custom_countdown_05", playerID)
				end
				
				if(math.floor(GameRules:GetDOTATime(false, true)) == -9 )
				then
					EmitAnnouncerSoundForPlayer("announcer_ann_custom_countdown_04", playerID)
				end
				
				if(math.floor(GameRules:GetDOTATime(false, true)) == -8 )
				then
					EmitAnnouncerSoundForPlayer("announcer_ann_custom_countdown_03", playerID)
				end
				
				if(math.floor(GameRules:GetDOTATime(false, true)) == -7 )
				then
					EmitAnnouncerSoundForPlayer("announcer_ann_custom_countdown_02", playerID)
				end
				
				if(math.floor(GameRules:GetDOTATime(false, true)) == -6 )
				then
					EmitAnnouncerSoundForPlayer("announcer_ann_custom_countdown_01", playerID)
				end

			end 

		end
	
	
	

			
		return 1
	end)
	
	
	for i = 1, 2, 1 do
		Entities:FindByName( nil, "watch_" .. i .. "_trigger_" .. "blue"):AddEffects( EF_NODRAW )
		Entities:FindByName( nil, "watch_" .. i .. "_trigger_" .. "red"):AddEffects( EF_NODRAW )
	end
	
	
	GameRules.koboldEntitiesPositions = {}
	GameRules.skullGolemPosition = nil

	local counter = 0

	for key,value in pairs(Entities:FindAllByModel("models/creeps/neutral_creeps/n_creep_kobold/kobold_c/n_creep_kobold_c.vmdl"))
	do
		counter =  counter + 1
		GameRules.koboldEntitiesPositions[counter] = value:GetAbsOrigin()
	end
	
	
	GameRules.skullGolemPosition = Entities:FindByModel(nil,"models/creeps/lane_creeps/creep_dire_hulk/creep_dire_ancient_hulk.vmdl"):GetAbsOrigin()
	
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

  --Convars:SetBool("dota_hide_cursor", true)

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
  
  --hero:AddNewModifier(hero, nil, "modifier_bush_hiding", {duration=.5}) 
  
  
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

   --initTowers()
   	for key,value in pairs(Entities:FindAllByName("customTowers")) do
		  
			local maxPoints = 20
		
		  
		  value.worldPanel = WorldPanels:CreateWorldPanelForAll(
      {layout = "file://{resources}/layout/custom_game/worldpanels/towerAmmo.xml",
        entity = value:GetEntityIndex(),
        entityHeight = 260,
		name = maxPoints
      })

	end
   
    for key,value in pairs(Entities:FindAllByModel("models/heroes/undying/undying_tower.vmdl")) do
		  
		local maxPoints = 40
		  
		 value.worldPanel = WorldPanels:CreateWorldPanelForAll(
			{layout = "file://{resources}/layout/custom_game/worldpanels/towerAmmo.xml",
				entity = value:GetEntityIndex(),
				entityHeight = 260,
				name = maxPoints
			})

	end
   
   
    -- Remove building invulnerability
    print("Make buildings vulnerable")
    local allBuildings = Entities:FindAllByClassname('npc_dota_building')
    for i = 1, #allBuildings, 1 do
        local building = allBuildings[i]
        if building:HasModifier('modifier_invulnerable') then
            building:RemoveModifierByName('modifier_invulnerable')
            --building:AddNewModifier(building, nil, "modifier_tower_truesight_aura", {})
        end
    end
   

   local startBlockers = Entities:FindAllByClassname("tutorial_npc_blocker")
   
   
       for i,v in ipairs(startBlockers)
	   do
		v:RemoveSelf()
	   end

   
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
	
	--SCAN for TOWERS
	
	Timers:CreateTimer(function()
	
		local allCreeps = Entities:FindAllByClassname('npc_dota_creep_lane')
		for i = 1, #allCreeps, 1 do

			local enemyTeam = 0
		
			if (allCreeps[i]:GetTeamNumber() == 2 )
			then
				enemyTeam = 3
			end
			
			if (allCreeps[i]:GetTeamNumber() == 3 )
			then
				enemyTeam = 2
			end
			
			
		
			local scannedUnits = FindUnitsInRadius(enemyTeam,
												allCreeps[i]:GetAbsOrigin(),
												nil,
												600,
												DOTA_UNIT_TARGET_TEAM_FRIENDLY,
												DOTA_UNIT_TARGET_ALL,
												DOTA_UNIT_TARGET_FLAG_NONE,
												FIND_ANY_ORDER,
												false)
								  
			for k, v in pairs(scannedUnits) do
				if (v:GetModelName() == "models/props_structures/tower_bad.vmdl" or v:GetModelName() == "models/props_structures/tower_good.vmdl")
				then
					local order = 
					{
						UnitIndex = allCreeps[i]:entindex(),
						OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
						TargetIndex = v:entindex()
					}
				
					ExecuteOrderFromTable(order)
				end
			end
		
		
		end

		return 2.0
	end)
	

	
end

function SpawnTop( teamselection , teamnumber, position)
		if (Entities:FindByName( nil, "npc_dota_spawner_".. teamselection .. "_top_".. position .. ""))
		then
		
			gridPositions = {}
			for i = 1,6 do
				table.insert(gridPositions, GetGridAroundPoint( 7, Entities:FindByName( nil, "lane_top_pathcorner_" .. teamselection .. "guys_" .. i ):GetAbsOrigin() ) )
			end
		
		
		
			local meleeCreep = CreateUnitByName("npc_dota_creep_".. teamselection .. "guys_melee", Entities:FindByName( nil, "npc_dota_spawner_".. teamselection .. "_top_".. position .. ""):GetAbsOrigin(), true, nil, nil, teamnumber)
			
				for i = 1,6 do
				
				ExecuteOrderFromTable({ UnitIndex = meleeCreep:entindex(), OrderType =  DOTA_UNIT_ORDER_ATTACK_MOVE , Position = gridPositions[i][1], Queue = true})
			
				end
		
			for ix = 5,6 do
				local meleeCreep = CreateUnitByName("npc_dota_creep_".. teamselection .. "guys_melee", Entities:FindByName( nil, "npc_dota_spawner_".. teamselection .. "_top_".. position .. ""):GetAbsOrigin(), true, nil, nil, teamnumber)
			
				for i = 1,6 do
				
				ExecuteOrderFromTable({ UnitIndex = meleeCreep:entindex(), OrderType =  DOTA_UNIT_ORDER_ATTACK_MOVE , Position = gridPositions[i][ix], Queue = true})
			
				end
			
			end
			
			for ix = 2,4 do
				local rangedCreep = CreateUnitByName("npc_dota_necronomicon_archer_1_custom", Entities:FindByName( nil, "npc_dota_spawner_".. teamselection .. "_top_".. position .. ""):GetAbsOrigin(), true, nil, nil, teamnumber)
			
				if ( teamselection == "bad") then
					rangedCreep:SetRenderColor(180,63,30)
				else
					rangedCreep:SetRenderColor(144,167,61)
				end
			
				for i = 1,6 do
				
				ExecuteOrderFromTable({ UnitIndex = rangedCreep:entindex(), OrderType =  DOTA_UNIT_ORDER_ATTACK_MOVE, Position = gridPositions[i][ix]  , Queue = true})
			
				end
			
			end
			
			
			local rangedMageCreep = CreateUnitByName("npc_dota_creep_".. teamselection .. "guys_ranged", Entities:FindByName( nil, "npc_dota_spawner_".. teamselection .. "_top_".. position .. ""):GetAbsOrigin(), true, nil, nil, teamnumber)
			for i = 1,6 do
				ExecuteOrderFromTable({ UnitIndex = rangedMageCreep:entindex(), OrderType =  DOTA_UNIT_ORDER_ATTACK_MOVE, Position = gridPositions[i][7]  , Queue = true})
			end
		
		end
end

function SpawnBot( teamselection , teamnumber, position )
		if (Entities:FindByName( nil, "npc_dota_spawner_".. teamselection .. "_bot_".. position .. ""))
		then
		
			gridPositions = {}
			for i = 1,4 do
				table.insert(gridPositions, GetGridAroundPoint( 7, Entities:FindByName( nil, "lane_bot_pathcorner_" .. teamselection .. "guys_" .. i ):GetAbsOrigin() ) )
			end
		
		
		
			local meleeCreep = CreateUnitByName("npc_dota_creep_".. teamselection .. "guys_melee", Entities:FindByName( nil, "npc_dota_spawner_".. teamselection .. "_bot_".. position .. ""):GetAbsOrigin(), true, nil, nil, teamnumber)
			
				for i = 1,4 do
				
				ExecuteOrderFromTable({ UnitIndex = meleeCreep:entindex(), OrderType =  DOTA_UNIT_ORDER_ATTACK_MOVE , Position = gridPositions[i][1], Queue = true})
			
				end
		
			for ix = 5,6 do
				local meleeCreep = CreateUnitByName("npc_dota_creep_".. teamselection .. "guys_melee", Entities:FindByName( nil, "npc_dota_spawner_".. teamselection .. "_bot_".. position .. ""):GetAbsOrigin(), true, nil, nil, teamnumber)
			
				for i = 1,4 do
				
				ExecuteOrderFromTable({ UnitIndex = meleeCreep:entindex(), OrderType =  DOTA_UNIT_ORDER_ATTACK_MOVE , Position = gridPositions[i][ix], Queue = true})
			
				end
			
			end
			
			for ix = 2,4 do
				local rangedCreep = CreateUnitByName("npc_dota_necronomicon_archer_1_custom", Entities:FindByName( nil, "npc_dota_spawner_".. teamselection .. "_bot_".. position .. ""):GetAbsOrigin(), true, nil, nil, teamnumber)
			
				if ( teamselection == "bad") then
					rangedCreep:SetRenderColor(180,63,30)
				else
					rangedCreep:SetRenderColor(144,167,61)
				end
			
			
				for i = 1,4 do
				
				ExecuteOrderFromTable({ UnitIndex = rangedCreep:entindex(), OrderType =  DOTA_UNIT_ORDER_ATTACK_MOVE, Position = gridPositions[i][ix]  , Queue = true})
			
				end
			
			end
			
			
			local rangedMageCreep = CreateUnitByName("npc_dota_creep_".. teamselection .. "guys_ranged", Entities:FindByName( nil, "npc_dota_spawner_".. teamselection .. "_bot_".. position .. ""):GetAbsOrigin(), true, nil, nil, teamnumber)
			for i = 1,4 do
				ExecuteOrderFromTable({ UnitIndex = rangedMageCreep:entindex(), OrderType =  DOTA_UNIT_ORDER_ATTACK_MOVE, Position = gridPositions[i][7]  , Queue = true})
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

function GameMode:FilterDamage( filterTable )

if (filterTable['entindex_victim_const'] and filterTable['entindex_attacker_const'] )
then
	local victim = EntIndexToHScript(filterTable['entindex_victim_const'])
	local caster = EntIndexToHScript(filterTable['entindex_attacker_const'])
	
	if (victim:GetTeamNumber() ~= caster:GetTeamNumber())
	then
		if (caster:HasModifier("modifier_invisible"))
		then
			caster:RemoveModifierByName("modifier_invisible")
			return true
		end
	
	
		if (victim:HasModifier("modifier_behindGate"))
		then
			return false
		end
	end
	
end

return true

end

function GameMode:FilterModifier( filterTable )

if (filterTable['entindex_parent_const'] and filterTable['entindex_caster_const'] )
then
	local victim = EntIndexToHScript(filterTable['entindex_parent_const'])
	local caster = EntIndexToHScript(filterTable['entindex_caster_const'])
	
	if (victim:GetTeamNumber() ~= caster:GetTeamNumber())
	then	
		if (victim:HasModifier("modifier_spirit_breaker_charge_of_darkness_vision"))
		then
			caster.chargeTarget = victim
			if (victim:GetAbsOrigin().y < 1257.65 and caster:GetAbsOrigin().y > 1257.65) then				
				return false
			end
			if (victim:GetAbsOrigin().y > 1257.65 and caster:GetAbsOrigin().y < 1257.65) then
				return false
			end
			
		end
	
		if (victim:HasModifier("modifier_behindGate"))
		then
			return false
		end
		if (victim:HasAbility("ability_building"))
		then
			return false
		end
		
	end
	
end



return true
end


-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()

  --Convars:SetBool("dota_hide_cursor", false)
  
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

  
  -- Filter Abilities
  GameRules:GetGameModeEntity():SetModifierGainedFilter( Dynamic_Wrap( GameMode, "FilterModifier" ), self )

  -- Filter Damage
  GameRules:GetGameModeEntity():SetDamageFilter( Dynamic_Wrap( GameMode, "FilterDamage" ), self )
  
  
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