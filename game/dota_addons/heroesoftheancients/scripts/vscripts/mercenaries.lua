function setContains(set, key)
    return set[key] ~= nil
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
		print(targetName)
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
	camp.respawnDelay = respawnDelaySecs
 
    mercenaryCamps[id] = camp
end

Timers:CreateTimer(function()
        for key,value in pairs(mercenaryCamps) do
			
			switch(mercenaryCamps[key].state) : caseof {
			[0]   = function (x) print(x,"ZERO") end,
			[1]   = function (x) print(x,"one") end,
			[2]   = function (x) print(x,"two") end,
			[3]   = 12345, -- this is an invalid case stmt
			  default = function (x) print(x,"default") end,
			  missing = function (x) print(x,"missing") end,
}
			
		end
	
return 1.0
end)
 
function onMercenaryDead(unit)
        for key,value in pairs(mercenaryCamps) do
            if (setContains(mercenaryCamps[key].spawnedMonsters,unit))
            then
            table.remove(mercenaryCamps[key].spawnedMonsters,unit)
            
			-- if no spawned monsters of a camp exist, switch to capture
			if next(mercenaryCamps[key].spawnedMonsters) == nil and mercenaryCamps[key].state == 0
			then
			   mercenaryCamps[key].state = 1
			end
			
			if next(mercenaryCamps[key].spawnedMonsters) == nil and mercenaryCamps[key].state == 2
			then
			   mercenaryCamps[key].state = 3
			end
			
            end
     
        end
end