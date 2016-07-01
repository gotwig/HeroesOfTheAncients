function GetIndex(list, element)
    for k, v in pairs(list) do
        if v == element then
            return k
        end
    end

    return nil
end
 
watchTowers = {}

onlyRunOnce = false

function initTowers(limitnumber)
	for i = 1,limitnumber do
		local tower = {}
		
		tower.positionFOWArea = Entities:FindByName(nil,"watch_" .. i .. "_fow"):GetAbsOrigin()
		tower.captureCounter = 50
		tower.captureGood = false
		tower.captureBad = false
		
		tower.capturedGood = false
		tower.capturedBad = false
		
		tower.onlyRunOnce = true
	 
		watchTowers[i] = tower
	end
end

Timers:CreateTimer(function()
        for key,value in pairs(watchTowers) do

			value.captureBad = false
			value.captureGood = false

			local tower = key
			for key,value in pairs(HeroList:GetAllHeroes()) do
							
				local unitCapture = Entities:FindByName(nil,"watch_" .. tower .. "_trigger"):IsTouching(value)
							
				if (unitCapture)
				then
					CustomGameEventManager:Send_ServerToPlayer(value:GetPlayerOwner() , "showCapturepoint", { name = "watch_" .. tower .. "_trigger" } )
							
					if (value:GetTeamNumber() == 2 )
					then
						watchTowers[tower].captureGood = true
					end
										
					if (value:GetTeamNumber() == 3 )
					then
						watchTowers[tower].captureBad = true
					end
										
					else
						if (value:GetPlayerOwner()) then
							CustomGameEventManager:Send_ServerToPlayer(value:GetPlayerOwner() , "hideCapturepoint", { name = "watch_" .. tower .. "_trigger" } )
						end
				end

			end
							
						
						
			if (watchTowers[key].captureCounter <  101 or watchTowers[key].captureCounter > -1 )
			then
				if ( not (value.captureBad and value.captureGood ))
				then
							
					if (value.captureBad)
					then
						watchTowers[key].captureCounter = watchTowers[key].captureCounter - 1;
					end
									
					if (value.captureGood)
					then
						watchTowers[key].captureCounter = watchTowers[key].captureCounter + 1;
					end

					end

			end
				
				if (watchTowers[key].captureCounter > 0 and watchTowers[key].captureCounter < 100)
				then
					watchTowers[key].onlyRunOnce = true
				end
				
				if (watchTowers[key].captureCounter <= 0)
				then
					AddFOWViewer( 3, watchTowers[key].positionFOWArea, 2000, 1.0, false)

					if (watchTowers[key].onlyRunOnce)
					then
						Entities:FindByName(nil, "watch_" .. tower .. "_trigger_" .. "blue"):AddEffects( EF_NODRAW )
						Entities:FindByName(nil, "watch_" .. tower .. "_trigger_" .. "red"):RemoveEffects( EF_NODRAW )
						watchTowers[key].onlyRunOnce = false
					end
					
				end
							
				if (watchTowers[key].captureCounter >= 100)
				then
					AddFOWViewer( 2, watchTowers[key].positionFOWArea, 2000, 1.0, false)
					
					if (watchTowers[key].onlyRunOnce)
					then
						Entities:FindByName(nil, "watch_" .. tower .. "_trigger_" .. "red"):AddEffects( EF_NODRAW )
						Entities:FindByName(nil, "watch_" .. tower .. "_trigger_" .. "blue"):RemoveEffects( EF_NODRAW )
						watchTowers[key].onlyRunOnce = false
					end
				end

				  
				CustomNetTables:SetTableValue( "watch_capturepoints", "watch_" .. key .. "_trigger", { value = watchTowers[key].captureCounter } )

		end
	
return 0.1
end)