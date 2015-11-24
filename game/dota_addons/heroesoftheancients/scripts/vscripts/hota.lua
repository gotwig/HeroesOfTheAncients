lockCamera = 0
MINESOPEN = false
MINESOPENLOADED = false
numSpawned = 0
numPlayerAmount = 0


print ('[HOTA] hota.lua' )


function hota:triggerMines(open)
if (open)
	then
		
		
		for key,value in pairs(Entities:FindAllByModel("models/creeps/neutral_creeps/n_creep_kobold/kobold_c/n_creep_kobold_c.vmdl"))
		do
		  value:ForceKill(false)
		end
		
		Entities:FindByModel(nil,"models/creeps/neutral_creeps/n_creep_golem_a/neutral_creep_golem_a.vmdl"):ForceKill(false)
		
		for key,value in pairs(GameRules.koboldEntitiesPositions)
			do  
				  CreateUnitByName("npc_dota_neutral_kobold", value, true, nil, nil, DOTA_TEAM_NEUTRALS)
		end
		
		CreateUnitByName("npc_dota_neutral_granite_golem", GameRules.skullGolemPosition, true, nil, nil, DOTA_TEAM_NEUTRALS)
		
		MINESOPEN = true
		print("The mines opened! Collect skulls")
	else
		MINESOPEN = false
		print("Support your skull golem / defend your base!")

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

--Listen for events


	

CustomGameEventManager:RegisterListener( "lockCameraToHero", Dynamic_Wrap(hota, "lockCameraToHero")) -- Check Camera Lock


CustomGameEventManager:RegisterListener( "moonwell_order", Dynamic_Wrap(hota, "MoonWellOrder")) --Right click through panorama
CustomGameEventManager:RegisterListener( "right_click_order", Dynamic_Wrap(hota, "RightClickOrder")) --Right click through panorama



