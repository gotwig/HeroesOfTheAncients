lockCamera = 0
MINESOPEN = false
MINESOPENLOADED = false
numSpawned = 0
numPlayerAmount = 0

require ('libraries/notifications')

print ('[HOTA] hota.lua' )

minesopentexts = {"Do you hear that clattering? I believe they're hungry...",'Enter heroes, the damned await.','Gather skulls and empower your golem!','Slay the undead and claim their skulls, heroes.',"There's no turning back now..."}


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
		
		
		Notifications:TopToAll({text=minesopentexts[RandomInt( 1, #minesopentexts )], duration=10.0})

		print("The mines opened! Collect skulls")
	else
		MINESOPEN = false
		

	end

end

function hota:lockCameraToHero( event )
local pID = event.pID

if (lockCamera == 0) 

then 
PlayerResource:SetCameraTarget(event.pID, PlayerResource:GetSelectedHeroEntity(event.pID))
lockCamera = 1

else
PlayerResource:SetCameraTarget(event.pID, nil)
lockCamera = 0

end 

end

function hota:flipMinimap( event )
local pID = event.pID

SendToConsole("toggle dota_hud_flip");

end

function hota:teleportBase( event )
local pID = event.pID

PlayerResource:GetSelectedHeroEntity(event.pID):CastAbilityNoTarget(PlayerResource:GetSelectedHeroEntity(event.pID):FindAbilityByName("lw_teleport"), 0) 
end



--Listen for events

CustomGameEventManager:RegisterListener( "flipMinimap", Dynamic_Wrap(hota, "flipMinimap")) -- Flip Minimap
CustomGameEventManager:RegisterListener( "teleportBase", Dynamic_Wrap(hota, "teleportBase")) --Right click through panorama
CustomGameEventManager:RegisterListener( "lockCameraToHero", Dynamic_Wrap(hota, "lockCameraToHero")) -- Check Camera Lock
CustomGameEventManager:RegisterListener( "moonwell_order", Dynamic_Wrap(hota, "MoonWellOrder")) --Right click through panorama



