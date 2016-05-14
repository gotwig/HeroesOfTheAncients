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

function bushStart(trigger)

  local hero = trigger.activator

  table.insert(previousHeroes, hero)
  
	local found = false;
    for k, v in pairs(previousHeroes) do
		if (v:IsNull())
		then
		  table.remove(previousHeroes, GetIndex(previousHeroes, v))
		end
		if (not v:IsNull())
		then
			if ( v:GetTeamNumber() ~= hero:GetTeamNumber() ) then
				 v:RemoveModifierByName("modifier_invisible")
				 found = true;
			end
		end
    end
	if (found == false)
	then
		if (hero:IsHero())
		then
			hero:AddNewModifier(hero, nil, "modifier_invisible", {})
		end
	end


end

function bushEnd(trigger)
  local hero = trigger.activator

  table.remove(previousHeroes, GetIndex(previousHeroes, hero))
  if (hero:IsHero())
  then
    Timers:CreateTimer({
    useGameTime = true,
    endTime = 0.3,
    callback = function()
		hero:RemoveModifierByName("modifier_invisible")
    end
	})
  
  end

  local found = false
  
  if (#previousHeroes > 0) then
	  if (not previousHeroes[1]:IsNull()) then 
		  if(previousHeroes[1]) then
				
				local lastNumber = previousHeroes[1]:GetTeamNumber()
				  for k, v in pairs(previousHeroes) do
					  if (v:IsNull())
					  then
					   table.remove(previousHeroes, GetIndex(previousHeroes, v))
					  end
				  
					  if (not v:IsNull()) then
					  
					  if ( v:GetTeamNumber() ~= lastNumber ) then
							 found = true
						end
						lastNumber = v:GetTeamNumber()

					  end
				  end
			  
			  if (found == false)
			  then
			  for k, v in pairs(previousHeroes) do
				  if (not v:IsNull()) then
				  if ( v:GetTeamNumber() ~= hero:GetTeamNumber() ) then
						if (v:IsHero())
						then
							v:AddNewModifier(hero, nil, "modifier_invisible", {})
						end
					end
					end
				  end
			  end
		  
		  end
	  end
  
  end


  end
