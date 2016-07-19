MINESOPEN = false
MINESOPENLOADED = false
numSpawned = 0
numPlayerAmount = 0

TEAMXP = {}
TEAMLEVEL = {}
TEAMXPPER = {}

require ('libraries/notifications')

for i=2, 3 do
      TEAMXP[i] = 0
end

for i=2, 3 do
      TEAMLEVEL[i] = 1
end

for i=2, 3 do
      TEAMXPPER[i] = 0
end

print ('[HOTA] hota.lua' )

minesopentexts = {"Do you hear that clattering? I believe they're hungry...",'Enter heroes, the damned await.','Gather skulls and empower your golem!','Slay the undead and claim their skulls, heroes.',"There's no turning back now..."}

abilityIndex = nil

function hota:triggerMines(open)
if (open)
	then
		
		
		for key,value in pairs(Entities:FindAllByModel("models/creeps/neutral_creeps/n_creep_kobold/kobold_c/n_creep_kobold_c.vmdl"))
		do
		  value:ForceKill(false)
		end
		
		if (Entities:FindByModel(nil,"models/creeps/lane_creeps/creep_dire_hulk/creep_dire_ancient_hulk.vmdl"))
		then
			Entities:FindByModel(nil,"models/creeps/lane_creeps/creep_dire_hulk/creep_dire_ancient_hulk.vmdl"):ForceKill(false)
		end		
		
		for key,value in pairs(GameRules.koboldEntitiesPositions)
			do  
				CreateUnitByName("npc_dota_neutral_kobold", value, true, nil, nil, DOTA_TEAM_NEUTRALS)
		end
		
		CreateUnitByName("npc_dota_neutral_skull_golem", GameRules.skullGolemPosition, true, nil, nil, DOTA_TEAM_NEUTRALS)
		
		MINESOPEN = true
		
		CustomGameEventManager:Send_ServerToAllClients( "showDynamicEventInfo", {} )
        CustomNetTables:SetTableValue( "dynamic_MapEvents", "dynamic_event" , { team1 = 0, team2 = 0, remaining = 100} )
		
		Notifications:TopToAll({text=minesopentexts[RandomInt( 1, #minesopentexts )], duration=10.0})

		print("The mines opened! Collect skulls")
		
		local firstMine = Entities:FindByName(nil,"mine_to_ug_top")
		local secondMine = Entities:FindByName(nil,"mine_to_ug_bot")
		local thirdMine = Entities:FindByName(nil,"minesOpenThirdPoint")


		
		for playerID = 0, DOTA_MAX_TEAM_PLAYERS do 

		local player = PlayerResource:GetPlayer(playerID)

		if PlayerResource:IsValidPlayerID(playerID) then 

			local playerHeroChar = PlayerResource:GetSelectedHeroEntity(playerID)
			MinimapEvent( player:GetTeamNumber(), playerHeroChar, firstMine:GetAbsOrigin().x, firstMine:GetAbsOrigin().y - 600, DOTA_MINIMAP_EVENT_HINT_LOCATION, 6 )

			Timers:CreateTimer({
				useGameTime = false,
				endTime = 6, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
				callback = function()
					MinimapEvent( player:GetTeamNumber(), playerHeroChar, secondMine:GetAbsOrigin().x, secondMine:GetAbsOrigin().y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 8 )
				end
			})
			
			Timers:CreateTimer({
				useGameTime = false,
				endTime = 14, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
				callback = function()
					MinimapEvent( player:GetTeamNumber(), playerHeroChar, thirdMine:GetAbsOrigin().x, thirdMine:GetAbsOrigin().y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 14 )
				end
			})
			
			EmitAnnouncerSound("announcer_ann_custom_cp_alerts_51")	
			
			
			teamSkullPoints[1] = 0
			teamSkullPoints[2] = 0

			CustomNetTables:SetTableValue( "dynamic_MapEvents", "dynamic_event" , { team1 = teamSkullPoints[1], team2 = teamSkullPoints[2], remaining = (100 - (teamSkullPoints[1] + teamSkullPoints[2]))} )
			
			
		end 

	end

	else
		MINESOPEN = false
		CustomGameEventManager:Send_ServerToAllClients( "hideDynamicEventInfo", {} )

	end

end

function hota:lockCameraToHero( event )
local pID = event.pID

if (not PlayerResource:GetPlayer(event.pID).lockCamera) 

then 
PlayerResource:SetCameraTarget(event.pID, EntIndexToHScript(event.entID))
PlayerResource:GetPlayer(event.pID).lockCamera = true

else
PlayerResource:SetCameraTarget(event.pID, nil)
PlayerResource:GetPlayer(event.pID).lockCamera = false

end 

end

function hota:flipMinimap( event )
local pID = event.pID

SendToConsole("toggle dota_hud_flip");

end

function hota:mountHorse( event )
	local caster = EntIndexToHScript(event.entID)
	caster:CastAbilityNoTarget(caster:GetItemInSlot(0), 0) 
end

function hota:teleportBase( event )
	local caster = EntIndexToHScript(event.entID)
	caster:CastAbilityNoTarget(caster:GetItemInSlot(1), 0) 
end


function hota:MoonWellOrder( event )
    local pID = event.pID
    local entityIndex = event.mainSelected
    local target = EntIndexToHScript(entityIndex)
    local targetIndex = event.targetIndex
    local moon_well = EntIndexToHScript(targetIndex)

    local replenish = moon_well:FindAbilityByName("nightelf_replenish_mana_and_life")
    moon_well:CastAbilityOnTarget(target, replenish, moon_well:GetPlayerOwnerID())
end

function hota:OnPlayerReconnect( event )

end

--Listen for events

CustomGameEventManager:RegisterListener( "flipMinimap", Dynamic_Wrap(hota, "flipMinimap")) -- Flip Minimap
CustomGameEventManager:RegisterListener( "teleportBase", Dynamic_Wrap(hota, "teleportBase")) 
CustomGameEventManager:RegisterListener( "mountHorse", Dynamic_Wrap(hota, "mountHorse")) 

CustomGameEventManager:RegisterListener( "lockCameraToHero", Dynamic_Wrap(hota, "lockCameraToHero")) -- Check Camera Lock
CustomGameEventManager:RegisterListener( "moonwell_order", Dynamic_Wrap(hota, "MoonWellOrder")) --Right click through panorama

--ListenToGameEvent("player_reconnected", Dynamic_Wrap(hota, 'OnPlayerReconnect'), self)


