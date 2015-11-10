lockCamera = 0
MINESOPEN = false
MINESOPENLOADED = false
numSpawned = 0
numPlayerAmount = 0

print ('[HOTA] hota.lua' )


function hota:triggerMines(open)
if (open)
	then
		MINESOPEN = true
		Say(nil, "The mines opened! Collect skulls", false)

	else
		MINESOPEN = false
		Say(nil, "Support your skull golem / defend your base!", false)

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



