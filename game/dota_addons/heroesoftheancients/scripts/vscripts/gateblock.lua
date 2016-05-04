require('libraries/timers')
  
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
    boxcollider.box = Physics:CreateBox(pointA,pointB, 3000, true)
  else
    boxcollider.box = Physics:CreateBox(pointA,pointB, 1800, true)
  end
  
boxcollider.test = function(self, unit)
  if (unit.IsRealHero and unit:IsRealHero() and unit:GetTeamNumber() == thisEntity:GetTeamNumber()) then
	
	mod = unit:FindModifierByName("modifier_invulnerable")
	if (mod)
	then
		mod:SetDuration(.06, true)
	else
		unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
	end
	
  end
  
  if ((unit:GetTeamNumber() ~= DOTA_TEAM_GOODGUYS) and (unit:GetTeamNumber() ~= DOTA_TEAM_BADGUYS) ) then
    return false
  else
    return unit:GetTeamNumber() ~= thisEntity:GetTeamNumber()
  end
  
end
  boxcollider.draw = true


    end
  })
  

