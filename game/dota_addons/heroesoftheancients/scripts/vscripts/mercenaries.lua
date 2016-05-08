require("libraries/worldpanels")

function GetIndex(list, element)
    for k, v in pairs(list) do
        if v == element then
            return k
        end
    end

    return nil
end

function switch(c)
  local swtbl = {
    casevar = c,
    caseof = function (self, code)
      local f
      if (self.casevar) then
        f = code[self.casevar] or code.default
      else
        f = code.missing or code.default
      end
      if f then
        if type(f)=="function" then
          return f(self.casevar,self)
        else
          error("case "..tostring(self.casevar).." not a function")
        end
      end
    end
  }
  return swtbl
end
 
mercenaryCamps = {}

onlyRunOnce = false

--[[
    STATE Codes for each mercenary camp:
	
	0 - Camp is ready to be killed (alive)
	1 - Camp is killed, ready to be captured
	2 - Camp got captured, ready to summon for the winning team
	3 - summoned camp got killed, trigger countdown, than reset to 0
--]]


function initCamp(id,limitnumber, respawnDelaySecs)
    local camp = {}
    local spawned = {}
    local toSpawn = {}
   
    for i = 1,limitnumber do
        local targetName = "merc_" .. id .. "_" .. i
        local unit = Entities:FindByName(nil,targetName)
        local unitData = {}
 
        unitData.name = unit:GetUnitName()
        unitData.position = unit:GetAbsOrigin()
        unitData.rotation = unit:GetForwardVector()
       
        unit:RemoveSelf()
       
        local newUnit = CreateUnitByName(unitData.name,
										 unitData.position,
										 true,
										 nil,
										 nil,
										 DOTA_TEAM_NEUTRALS)
										 
        newUnit:SetForwardVector(unitData.rotation)
       
        table.insert(spawned, newUnit)
        table.insert(toSpawn, unitData)
    end
 
    camp.monstersToSpawn = toSpawn
    camp.spawnedMonsters = spawned
	camp.state = 0
	camp.captureCounter = 50
	camp.allyTeam = 0
	camp.captureGood = false
	camp.captureBad = false
	
	camp.wp = nil
	
	camp.onlyRunOnce = true
	camp.respawnDelay = respawnDelaySecs
	camp.currentDelay = respawnDelaySecs
 
    mercenaryCamps[id] = camp
		
	  Timers:CreateTimer(1, function()
	WorldPanels:CreateWorldPanelForAll(
		{layout = "file://{resources}/layout/custom_game/worldpanels/arrow.xml",
			position = Entities:FindByName(nil, "merc_" .. id .. "_delay"):GetAbsOrigin() + Vector(0,80,0)
		})
		
	 --Level stuff
	 Entities:FindByName(nil, "merc_" .. id .. "_delay"):FindAbilityByName("dummy_unit"):SetLevel(1)
	
		
	end)
	

	
end

function respawnCamp(id)

	for key,unitData in pairs(mercenaryCamps[id].monstersToSpawn) do

		local newUnit = CreateUnitByName(unitData.name,
												 unitData.position,
												 true,
												 nil,
												 nil,
												 DOTA_TEAM_NEUTRALS)
												 
		newUnit:SetForwardVector(unitData.rotation)
		table.insert(mercenaryCamps[id].spawnedMonsters,newUnit)	

	end
	
	if (mercenaryCamps[id].state == 3)
	then
		mercenaryCamps[id].currentDelay = mercenaryCamps[id].respawnDelay
		mercenaryCamps[id].state = 0
		mercenaryCamps[id].captureCounter = 50
	end
	
end

function respawnAllyCamp(id)

	for key,unitData in pairs(mercenaryCamps[id].monstersToSpawn) do

		local newUnit = CreateUnitByName(unitData.name .. "_ally",
												 unitData.position,
												 true,
												 nil,
												 nil,
												 mercenaryCamps[id].allyTeam)
												 
		newUnit:SetForwardVector(unitData.rotation)
		
		if (mercenaryCamps[id].allyTeam == 2)
		then
			for i = 3,6 do
				ExecuteOrderFromTable({ UnitIndex = newUnit:GetEntityIndex(), OrderType =  DOTA_UNIT_ORDER_ATTACK_MOVE , Position = Entities:FindByName( nil, "lane_top_pathcorner_goodguys_" .. i ):GetAbsOrigin(), Queue = true})
			end
		end
		
		if (mercenaryCamps[id].allyTeam == 3)
		then
			for i = 3,6 do
				ExecuteOrderFromTable({ UnitIndex = newUnit:GetEntityIndex(), OrderType =  DOTA_UNIT_ORDER_ATTACK_MOVE , Position = Entities:FindByName( nil, "lane_top_pathcorner_badguys_" .. i ):GetAbsOrigin(), Queue = true})
			end
		end
		
		table.insert(mercenaryCamps[id].spawnedMonsters,newUnit)	

	end
	
end

Timers:CreateTimer(function()
        for key,value in pairs(mercenaryCamps) do

		

			switch(mercenaryCamps[key].state) : caseof 
				{
				[1]   = function (x)
							local merc = key
						
							value.captureBad = false
							value.captureGood = false
							
							for key,value in pairs(HeroList:GetAllHeroes()) do
							
							local unitCapture = Entities:FindByName(nil,"merc_" .. merc .. "_trigger"):IsTouching(value)
						
								if (unitCapture)
								then
									CustomGameEventManager:Send_ServerToPlayer(value:GetPlayerOwner() , "showCapturepoint", { name = "merc_" .. merc .. "_trigger" } )
									
									if (value:GetTeamNumber() == 2 )
									then
										mercenaryCamps[merc].captureGood = true
									end
									
									if (value:GetTeamNumber() == 3 )
									then
										mercenaryCamps[merc].captureBad = true
									end
									
									
								else
									CustomGameEventManager:Send_ServerToPlayer(value:GetPlayerOwner() , "hideCapturepoint", { name = "merc_" .. merc .. "_trigger" } )
								end

							end
							
							if (not value.captureGood and not value.captureBad)
							then
								value.captureCounter = 50
							end
						
						
						
							if (mercenaryCamps[key].captureCounter ~=  100 or mercenaryCamps[key].captureCounter ~= 0 )
							then
								if ( not (value.captureBad and value.captureGood ))
								then
								
									if (value.captureBad)
									then
										mercenaryCamps[key].captureCounter = mercenaryCamps[key].captureCounter - 1;
									end
									
									if (value.captureGood)
									then
										mercenaryCamps[key].captureCounter = mercenaryCamps[key].captureCounter + 1;
									end

								end
							
								CustomNetTables:SetTableValue( "merc_capturepoints", "merc_" .. key .. "_trigger" , { value = mercenaryCamps[key].captureCounter } )
							end
							
							if (mercenaryCamps[key].captureCounter <= 0)
							then
							
							print("red wins")
							changeState(key, 2)
							value.allyTeam = 3;
							CustomGameEventManager:Send_ServerToAllClients( "hideCapturepoint", { name = "merc_" .. key .. "_trigger" } )
							
							EmitAnnouncerSoundForTeam("announcer_ann_custom_adventure_alerts_30", 3)
							EmitAnnouncerSoundForTeam("announcer_ann_custom_adventure_alerts_32", 2)
							
							end
							
							if (mercenaryCamps[key].captureCounter >= 100)
							then
							print("blue wins")
							changeState(key, 2)
							value.allyTeam = 2;
							CustomGameEventManager:Send_ServerToAllClients( "hideCapturepoint", { name = "merc_" .. key .. "_trigger" } )
							
							EmitAnnouncerSoundForTeam("announcer_ann_custom_adventure_alerts_30", 2)
							EmitAnnouncerSoundForTeam("announcer_ann_custom_adventure_alerts_32", 3)

							end

						
						end,
				  default = function (x)  end,
				  missing = function (x)  end,
				}
			
			if (not mercenaryCamps[key].onlyRunOnce)
			then
				switch(mercenaryCamps[key].state) : caseof 
				{
				[0]   = function (x) print(x,"ZERO") 
						respawnCamp(key)
						end,
				[1]   = function (x) print(x,"one")
						mercenaryCamps[key].captureCounter = 50
						CustomNetTables:SetTableValue( "merc_capturepoints", "merc_" .. key, { value = mercenaryCamps[key].captureCounter } )
						end,
				[2]   = function (x) print(x,"two")
						respawnAllyCamp(key)
						
						mercenaryCamps[key].wp = WorldPanels:CreateWorldPanelForAll(
						{layout = "file://{resources}/layout/custom_game/worldpanels/mercSpawnCount.xml",
							entity = Entities:FindByName(nil, "merc_" .. key .. "_delay"):GetEntityIndex(),
							name = "merc_"  .. key .. "_delay"
						})
						
						end,
				[3]   = function (x) print(x,"three")
				    print("merc_"  .. key .. " _trigger")
	
						 local decreaseTimer = Timers:CreateTimer(0, function()
								mercenaryCamps[key].currentDelay = mercenaryCamps[key].currentDelay - 1
								CustomNetTables:SetTableValue( "merc_capturepoints", "merc_" .. key .. "_delay" , { value = mercenaryCamps[key].currentDelay } )
							  return 1.0
							end
						  )
	
					
						Timers:CreateTimer( mercenaryCamps[key].respawnDelay, function()
										mercenaryCamps[key].wp:Delete()
										respawnCamp(key)
										Timers:RemoveTimer(decreaseTimer)
									end
						)

					
					
						end,
				  default = function (x) end,
				  missing = function (x) end,
				}
			mercenaryCamps[key].onlyRunOnce = true
			end
			
			
		end
	
return 0.1
end)
 
 
 function changeState(id, newState)
	mercenaryCamps[id].state = newState
	mercenaryCamps[id].onlyRunOnce = false
 end

function onMercenaryDead(unit)
        for key,value in pairs(mercenaryCamps) do
			local index = GetIndex(mercenaryCamps[key].spawnedMonsters,unit)
			if (index)
            then
				table.remove(mercenaryCamps[key].spawnedMonsters,index)	
				
				-- if no spawned monsters of a camp exist, switch to capture
				if next(mercenaryCamps[key].spawnedMonsters) == nil and mercenaryCamps[key].state == 0
				then
				   changeState(key, 1)
				end
			
				if next(mercenaryCamps[key].spawnedMonsters) == nil and mercenaryCamps[key].state == 2
				then
				   changeState(key, 3)
				end
			
            end
     
        end
end