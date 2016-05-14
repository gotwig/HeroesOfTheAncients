MINESOPEN = false
MINESOPENLOADED = false
numSpawned = 0
numPlayerAmount = 0

require ('libraries/notifications')

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
		
		if (Entities:FindByModel(nil,"models/creeps/neutral_creeps/n_creep_golem_a/neutral_creep_golem_a.vmdl"))
		then
			Entities:FindByModel(nil,"models/creeps/neutral_creeps/n_creep_golem_a/neutral_creep_golem_a.vmdl"):ForceKill(false)
		end		
		
		for key,value in pairs(GameRules.koboldEntitiesPositions)
			do  
				CreateUnitByName("npc_dota_neutral_kobold", value, true, nil, nil, DOTA_TEAM_NEUTRALS)
		end
		
		CreateUnitByName("npc_dota_neutral_granite_golem", GameRules.skullGolemPosition, true, nil, nil, DOTA_TEAM_NEUTRALS)
		
		MINESOPEN = true
		
		CustomGameEventManager:Send_ServerToAllClients( "showDynamicEventInfo", {} )
        CustomNetTables:SetTableValue( "dynamic_MapEvents", "dynamic_event" , { team1 = 0, team2 = 0, remaining = 100} )

		
		Notifications:TopToAll({text=minesopentexts[RandomInt( 1, #minesopentexts )], duration=10.0})

		print("The mines opened! Collect skulls")
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


--Listen for events

CustomGameEventManager:RegisterListener( "flipMinimap", Dynamic_Wrap(hota, "flipMinimap")) -- Flip Minimap
CustomGameEventManager:RegisterListener( "teleportBase", Dynamic_Wrap(hota, "teleportBase")) 
CustomGameEventManager:RegisterListener( "mountHorse", Dynamic_Wrap(hota, "mountHorse")) 

CustomGameEventManager:RegisterListener( "lockCameraToHero", Dynamic_Wrap(hota, "lockCameraToHero")) -- Check Camera Lock
CustomGameEventManager:RegisterListener( "moonwell_order", Dynamic_Wrap(hota, "MoonWellOrder")) --Right click through panorama



