require('libraries/timers')

LinkLuaModifier("modifier_behindGate", "modifiers/modifier_behindGate", LUA_MODIFIER_MOTION_NONE)


function GetIndex(list, element)
    for k, v in pairs(list) do
        if v == element then
            return k
        end
    end

    return nil
end
  
  local previousHeroes = {}
  
  Timers:CreateTimer({
    endTime = 1, 
    callback = function()
	
  local pointA = Entities:FindByName(nil, thisEntity:GetName() .. "_start"):GetAbsOrigin()
  local pointB = Entities:FindByName(nil, thisEntity:GetName() .. "_end"):GetAbsOrigin()

local boxcollider = Physics:AddCollider(thisEntity:GetName(), Physics:ColliderFromProfile("boxblocker"))

  if (string.sub(thisEntity:GetName(), 6,6) == "1")
  then
    boxcollider.box = Physics:CreateBox(pointA,pointB, 2700, true)
  else
    boxcollider.box = Physics:CreateBox(pointA,pointB, 1800, true)
  end
  
boxcollider.test = function(self, unit)
  if (unit.IsRealHero and unit:IsRealHero() and unit:GetTeamNumber() == thisEntity:GetTeamNumber()) then
	
	mod = unit:FindModifierByName("modifier_behindGate")
	if (mod)
	then
		mod:SetDuration(.06, true)
	else
		unit:AddNewModifier(unit, nil, "modifier_behindGate", {duration=0.12})
	end

	
  end
  
  if ((unit:GetTeamNumber() ~= DOTA_TEAM_GOODGUYS) and (unit:GetTeamNumber() ~= DOTA_TEAM_BADGUYS) ) then
    return false
  else
	if (unit:GetTeamNumber() ~= thisEntity:GetTeamNumber()) then
		if (unit) then
			if (unit:IsHero())
			then
				if (unit:HasModifier("modifier_spirit_breaker_charge_of_darkness")) then
					unit:AddNewModifier(v, nil, "modifier_breaker_stun", {duration = 0.06})
					return unit:GetTeamNumber() ~= thisEntity:GetTeamNumber()
				else
					return unit:GetTeamNumber() ~= thisEntity:GetTeamNumber()
				end
			end
		end
	
	end
	
    return unit:GetTeamNumber() ~= thisEntity:GetTeamNumber()

  end
  
end
  boxcollider.draw = false


    end
  })
  

