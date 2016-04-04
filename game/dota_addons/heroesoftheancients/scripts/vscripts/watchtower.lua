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
		
		local unit = Entities:FindByName(nil,"watch_" .. i .. "_trigger")
		
		tower.position = unit:GetAbsOrigin()
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
						CustomGameEventManager:Send_ServerToPlayer(value:GetPlayerOwner() , "hideCapturepoint", { name = "watch_" .. tower .. "_trigger" } )
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
							
				if (watchTowers[key].captureCounter <= 0)
				then
					AddFOWViewer( 3, watchTowers[key].position, 3000, 1.0, false)
				end
							
				if (watchTowers[key].captureCounter >= 100)
				then
					AddFOWViewer( 2, watchTowers[key].position, 3000, 1.0, false)
				end

				  
				CustomNetTables:SetTableValue( "watch_capturepoints", "watch_" .. key .. "_trigger", { value = watchTowers[key].captureCounter } )

		end
	
return 0.1
end)