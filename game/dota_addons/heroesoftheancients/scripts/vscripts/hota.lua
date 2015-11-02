lockCamera = 0;

print ('[HOTA] hota.lua' )

--Always follow the maincharachter, deactivate custom 
--option missing yet

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



