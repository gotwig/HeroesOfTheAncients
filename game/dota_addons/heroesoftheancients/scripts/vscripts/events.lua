-- This file contains all barebones-registered events and has already set up the passed-in parameters for your use.
-- Do not remove the GameMode:_Function calls in these events as it will mess with the internal barebones systems.

require ('maps/hauntedmines/skulls')
require ('units/keep_destroyed')
require ('units/gate_destroyed')
require ('units/teleportBase')
require ('units/mountHorse')
require ('units/sound')
require ('healthglobe')
require ('mercenaries')
require ('watchtower')

   -- STUFF

GameRules.goodkeeps = {}
GameRules.goodkeeps["top"] = {}

for j = 1, 5 do
        GameRules.goodkeeps["top"][j] = true
end

GameRules.goodkeeps["bot"] = {}

for j = 1, 5 do
        GameRules.goodkeeps["bot"][j] = true
end


GameRules.badkeeps = {}
GameRules.badkeeps["top"] = {}

for j = 1, 2 do
        GameRules.badkeeps["top"][j] = true
end

GameRules.badkeeps["bot"] = {}

for j = 1, 2 do
        GameRules.badkeeps["bot"][j] = true
end


MINESOPENLOADED = false

-- Cleanup a player when they leave
function GameMode:OnDisconnect(keys)
  DebugPrint('[BAREBONES] Player Disconnected ' .. tostring(keys.userid))
  DebugPrintTable(keys)
  
  local name = keys.name
  local networkid = keys.networkid
  local reason = keys.reason
  local userid = keys.userid

end
-- The overall game state has changed
function GameMode:OnGameRulesStateChange(keys)
  DebugPrint("[BAREBONES] GameRules State Changed")
  DebugPrintTable(keys)

  -- This internal handling is used to set up main barebones functions
  GameMode:_OnGameRulesStateChange(keys)

  local newState = GameRules:State_Get()
end

-- An NPC has spawned somewhere in game.  This includes heroes
function GameMode:OnNPCSpawned(keys)
  -- This internal handling is used to set up main barebones functions
  GameMode:_OnNPCSpawned(keys)

  local npc = EntIndexToHScript(keys.entindex)
  
  
  if (npc:IsIllusion()) then
	if (npc:GetOwnerEntity()) then
		--npc:AddNewModifier(npc, nil, "modifier_no_health", {})
		
		npc.worldPanel = WorldPanels:CreateWorldPanelForAll(
		  {layout = "file://{resources}/layout/custom_game/worldpanels/healthbar.xml",
			entity = npc:GetEntityIndex(),
			entityHeight = 260,
			name =  npc:GetPlayerOwnerID() + 1
		  })

	end
  
  end
  
  
  if ( npc:IsRealHero() ) then   
  
	if (GameMode.State == 2) then
		PlayerResource:SetCameraTarget(npc:GetPlayerOwnerID(), npc)
		npc:AddNewModifier(npc, nil, "modifier_rootedPreGame", {}) 
		npc:AddEffects( EF_NODRAW )
  
	else
		--npc:AddNewModifier(npc, nil, "modifier_no_health", {})
	
		if ( not npc:HasItemInInventory("item_mountHorse") )
			then
				npc:AddItemByName("item_mountHorse")
		end
	  
		if ( not npc:HasItemInInventory("item_teleportBase") )
			then
				npc:AddItemByName("item_teleportBase")
		end
		
		if ( not npc:HasItemInInventory("item_boots_of_riding") )
			then
				npc:AddItemByName("item_boots_of_riding")
		end
	end

	
  end
  
  
end

-- An entity somewhere has been hurt.  This event fires very often with many units so don't do too many expensive
-- operations here
function GameMode:OnEntityHurt(keys)
  --DebugPrint("[BAREBONES] Entity Hurt")
  --DebugPrintTable(keys)

  local damagebits = keys.damagebits -- This might always be 0 and therefore useless
  if keys.entindex_attacker ~= nil and keys.entindex_killed ~= nil then
    local entCause = EntIndexToHScript(keys.entindex_attacker)
    local entVictim = EntIndexToHScript(keys.entindex_killed)

    -- The ability/item used to damage, or nil if not damaged by an item/ability
    local damagingAbility = nil

    if keys.entindex_inflictor ~= nil then
      damagingAbility = EntIndexToHScript( keys.entindex_inflictor )
    end
  end
end

-- An item was picked up off the ground
function GameMode:OnItemPickedUp(keys)
  DebugPrint( '[BAREBONES] OnItemPickedUp' )
  DebugPrintTable(keys)

  local heroEntity = EntIndexToHScript(keys.HeroEntityIndex)
  local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local itemname = keys.itemname
  
--heroEntity.healthDropPlace = heroEntity:GetAbsOrigin()
  
end

-- A player has reconnected to the game.  This function can be used to repaint Player-based particles or change
-- state as necessary
function GameMode:OnPlayerReconnect(keys)
  DebugPrint( '[BAREBONES] OnPlayerReconnect' )
  DebugPrintTable(keys) 
  
  Timers:CreateTimer({
    useGameTime = false,
    endTime = 3, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
    callback = function()
      	if( MINESOPEN )then
			CustomGameEventManager:Send_ServerToAllClients( "showDynamicEventInfo", {} )
		end
    end
  })
end

-- An ability was used by a player
function GameMode:OnAbilityUsed(keys)
  DebugPrint('[BAREBONES] AbilityUsed')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local abilityname = keys.abilityname
  
  local caster = PlayerResource:GetSelectedHeroEntity(keys.PlayerID)
  if (caster:HasItemInInventory("item_boots_of_riding"))
  then
  		local item = caster:GetItemInSlot(2)
		caster:RemoveItem(item)
  end
	
	
end

-- A non-player entity (necro-book, chen creep, etc) used an ability
function GameMode:OnNonPlayerUsedAbility(keys)
  DebugPrint('[BAREBONES] OnNonPlayerUsedAbility')
  DebugPrintTable(keys)

  local abilityname=  keys.abilityname
end

-- A player changed their name
function GameMode:OnPlayerChangedName(keys)
  DebugPrint('[BAREBONES] OnPlayerChangedName')
  DebugPrintTable(keys)

  local newName = keys.newname
  local oldName = keys.oldName
end

-- A player leveled up an ability
function GameMode:OnPlayerLearnedAbility( keys)
  DebugPrint('[BAREBONES] OnPlayerLearnedAbility')
  DebugPrintTable(keys)

  local player = EntIndexToHScript(keys.player)
  local abilityname = keys.abilityname
end

-- A channelled ability finished by either completing or being interrupted
function GameMode:OnAbilityChannelFinished(keys)
  DebugPrint('[BAREBONES] OnAbilityChannelFinished')
  DebugPrintTable(keys)

  local abilityname = keys.abilityname
  local interrupted = keys.interrupted == 1
end

-- A player leveled up
function GameMode:OnPlayerLevelUp(keys)

  DebugPrint('[BAREBONES] OnPlayerLevelUp')
  DebugPrintTable(keys)

  local player = EntIndexToHScript(keys.player)
  local level = keys.level
  local teamNumber = PlayerResource:GetTeam(player:GetPlayerID())
  
  print("teamNUMBER:" .. teamNumber)
  
  CustomGameEventManager:Send_ServerToAllClients( "dota_player_gained_level_all", {team = teamNumber, level = keys.level} )

  
  if MINESOPENLOADED then return end

  
  local heroes = HeroList:GetAllHeroes()
  local allOver = true
	for i=0,DOTA_MAX_TEAM_PLAYERS-1 do
	  if PlayerResource:IsValidPlayer(i) and PlayerResource:GetLevel(i) < 3 then
		allOver = false
		break
	  end
	end

	if allOver then
	  MINESOPENLOADED = true
	  hota:triggerMines(true)
	end
  
end

-- A player last hit a creep, a tower, or a hero
function GameMode:OnLastHit(keys)
  DebugPrint('[BAREBONES] OnLastHit')
  DebugPrintTable(keys)

  local isFirstBlood = keys.FirstBlood == 1
  local isHeroKill = keys.HeroKill == 1
  local isTowerKill = keys.TowerKill == 1
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local killedEnt = EntIndexToHScript(keys.EntKilled)
end

-- A tree was cut down by tango, quelling blade, etc
function GameMode:OnTreeCut(keys)
  DebugPrint('[BAREBONES] OnTreeCut')
  DebugPrintTable(keys)

  local treeX = keys.tree_x
  local treeY = keys.tree_y
end

-- A rune was activated by a player
function GameMode:OnRuneActivated (keys)
  DebugPrint('[BAREBONES] OnRuneActivated')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local rune = keys.rune

  -- ADD XP
  if (keys.rune == DOTA_RUNE_BOUNTY ) then
		return
  end
  
  --[[ Rune Can be one of the following types
  DOTA_RUNE_DOUBLEDAMAGE
  DOTA_RUNE_HASTE
  DOTA_RUNE_HAUNTED
  DOTA_RUNE_ILLUSION
  DOTA_RUNE_INVISIBILITY
  DOTA_RUNE_BOUNTY
  DOTA_RUNE_MYSTERY
  DOTA_RUNE_RAPIER
  DOTA_RUNE_REGENERATION
  DOTA_RUNE_SPOOKY
  DOTA_RUNE_TURBO
  ]]
end

-- A player took damage from a tower
function GameMode:OnPlayerTakeTowerDamage(keys)
  DebugPrint('[BAREBONES] OnPlayerTakeTowerDamage')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local damage = keys.damage
end

-- A player picked a hero
function GameMode:OnPlayerPickHero(keys)
  DebugPrint('[BAREBONES] OnPlayerPickHero')
  DebugPrintTable(keys)

  local heroClass = keys.hero
  local heroEntity = EntIndexToHScript(keys.heroindex)
  local player = EntIndexToHScript(keys.player)
end

-- A player killed another player in a multi-team context
function GameMode:OnTeamKillCredit(keys)
  DebugPrint('[BAREBONES] OnTeamKillCredit')
  DebugPrintTable(keys)

  local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
  local victimPlayer = PlayerResource:GetPlayer(keys.victim_userid)
  local numKills = keys.herokills
  local killerTeamNumber = keys.teamnumber
end

-- An entity died
function GameMode:OnEntityKilled( keys )
  DebugPrint( '[BAREBONES] OnEntityKilled Called' )
  DebugPrintTable( keys )

  GameMode:_OnEntityKilled( keys )
  
  -- The Unit that was Killed
  local killedUnit = EntIndexToHScript( keys.entindex_killed )
  -- The Killing entity
  local killerEntity = nil

  if keys.entindex_attacker ~= nil then
    killerEntity = EntIndexToHScript( keys.entindex_attacker )
  end

  -- The ability/item used to kill, or nil if not killed by an item/ability
  local killerAbility = nil

  if keys.entindex_inflictor ~= nil then
    killerAbility = EntIndexToHScript( keys.entindex_inflictor )
  end

  local damagebits = keys.damagebits -- This might always be 0 and therefore useless

  -- Put code here to handle when an entity gets killed
 		
  -- set custom game over message
  if (killedUnit:GetUnitName() == "npc_dota_badguys_fort_custom")
  then
	GameRules:SetCustomVictoryMessage( "BLUE WINS! - RED DEFEAT" )
  end
		
  if (killedUnit:GetUnitName() == "npc_dota_goodguys_fort_custom")
  then
	GameRules:SetCustomVictoryMessage( "RED WINS! - BLUE DEFEAT" )
  end		
		
  --handle death of Heroes
  
  if (killedUnit:IsRealHero())
  then	
	local deathMessage = " team hero killed"

	if (killedUnit:GetTeamNumber() == 2 )
	then
		deathMessage = "Blue " .. deathMessage
		deathMessage = string.upper(deathMessage)
		
	    Notifications:TopToAll({text=deathMessage, style={color="red"}, duration=8.0})
		Notifications:TopToAll({hero=killedUnit:GetUnitName(), duration=8.0, imagestyle="icon"})
		
		
	elseif (killedUnit:GetTeamNumber() == 3 )
	then
		deathMessage = "Red " .. deathMessage
		deathMessage = string.upper(deathMessage)
		
		Notifications:TopToAll({text=deathMessage, style={color="#52e2ff"}, duration=8.0})
		Notifications:TopToAll({hero=killedUnit:GetUnitName(), duration=8.0, imagestyle="icon"})

	end
	Notifications:Top(killedUnit:GetPlayerID(), {text="YOU HAVE DIED", style={color="red"}, duration=3.0})


  end
		
		
  destroyedKeep(killedUnit)

	-- actual NPCS
  deadTrigger(killedUnit)
   
  -- drop health globes
  dropHealthGlobe(killedUnit)
  
  -- mercenary camps
  onMercenaryDead(killedUnit)
  
  onGateDeath(killedUnit)
  
end



-- This function is called 1 to 2 times as the player connects initially but before they 
-- have completely connected
function GameMode:PlayerConnect(keys)
  DebugPrint('[BAREBONES] PlayerConnect')
  DebugPrintTable(keys)
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function GameMode:OnConnectFull(keys)
  DebugPrint('[BAREBONES] OnConnectFull')
  DebugPrintTable(keys)

  GameMode:_OnConnectFull(keys)
  
  local entIndex = keys.index+1
  -- The Player entity of the joining user
  local ply = EntIndexToHScript(entIndex)
  
  -- The Player ID of the joining player
  local playerID = ply:GetPlayerID()
  
    	-- Sync Attribute Bonuses with Clients
		Timers:CreateTimer(function()
			for k, v in pairs( HeroList:GetAllHeroes() ) do
				CustomNetTables:SetTableValue( "hero_attributes", "" .. v:entindex(), { str = v:GetStrength(), agi = v:GetAgility(), int = v:GetIntellect() } )

				
				-- Forbid spirit breaker to rush from ug to top or other side around
				if(v.chargeTarget) then				
					if (v.chargeTarget:GetAbsOrigin().y < 626 and v:GetAbsOrigin().y > 626 ) then
						v:AddNewModifier(v, nil, "modifier_breaker_stun", {duration = 0.06})

					end
					if (v.chargeTarget:GetAbsOrigin().y > 626 and v:GetAbsOrigin().y < 626 ) then
						v:AddNewModifier(v, nil, "modifier_breaker_stun", {duration = 0.06})

					end
					if (not v:HasModifier("modifier_spirit_breaker_charge_of_darkness")) then
						print("no target anymore")
						v.chargeTarget = nil
					end
				end
			end
		return 0.1
	end)
  
  
end

-- This function is called whenever illusions are created and tells you which was/is the original entity
function GameMode:OnIllusionsCreated(keys)
  DebugPrint('[BAREBONES] OnIllusionsCreated')
  DebugPrintTable(keys)

  local originalEntity = EntIndexToHScript(keys.original_entindex)
end

-- This function is called whenever an ability begins its PhaseStart phase (but before it is actually cast)
function GameMode:OnAbilityCastBegins(keys)
  DebugPrint('[BAREBONES] OnAbilityCastBegins')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local abilityName = keys.abilityname
end

-- This function is called whenever a tower is killed
function GameMode:OnTowerKill(keys)
  DebugPrint('[BAREBONES] OnTowerKill')
  DebugPrintTable(keys)

  local gold = keys.gold
  local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
  local team = keys.teamnumber
end

-- This function is called whenever a player changes there custom team selection during Game Setup 
function GameMode:OnPlayerSelectedCustomTeam(keys)
  DebugPrint('[BAREBONES] OnPlayerSelectedCustomTeam')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.player_id)
  local success = (keys.success == 1)
  local team = keys.team_id
end

-- This function is called whenever an NPC reaches its goal position/target
function GameMode:OnNPCGoalReached(keys)
  DebugPrint('[BAREBONES] OnNPCGoalReached')
  DebugPrintTable(keys)

  local goalEntity = EntIndexToHScript(keys.goal_entindex)
  local nextGoalEntity = EntIndexToHScript(keys.next_goal_entindex)
  local npc = EntIndexToHScript(keys.npc_entindex)
end

-- This function is called whenever any player sends a chat message to team or All
function GameMode:OnPlayerChat(keys)
  local teamonly = keys.teamonly
  local userID = keys.userid
  local playerID = self.vUserIds[userID]:GetPlayerID()

  local text = keys.text
end



