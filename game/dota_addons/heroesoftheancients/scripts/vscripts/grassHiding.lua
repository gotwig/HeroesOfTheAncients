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
  print('bush start')
  print(trigger.activator:GetClassname())

  local hero = trigger.activator

  table.insert(previousHeroes, hero)
  
	local found = false;
    for k, v in pairs(previousHeroes) do
        if ( v:GetTeamNumber() ~= hero:GetTeamNumber() ) then
			 v:RemoveModifierByName("modifier_invisible")
			 found = true;
        end
    end
	if (found == false)
	then
	    hero:AddNewModifier(hero, nil, "modifier_invisible", {})
	end


end

function bushEnd(trigger)
  print('bush end')
  print(trigger.activator:GetClassname())

  local hero = trigger.activator

  table.remove(previousHeroes, GetIndex(previousHeroes, hero))
  hero:RemoveModifierByName("modifier_invisible")

  local found = false
  
  if(previousHeroes[1])
  then
  
		local lastNumber = previousHeroes[1]:GetTeamNumber()
		  for k, v in pairs(previousHeroes) do
		  if ( v:GetTeamNumber() ~= lastNumber ) then
				 found = true
			end
			lastNumber = v:GetTeamNumber()

		  end
	  
	  if (found == false)
	  then
	  for k, v in pairs(previousHeroes) do
		  if ( v:GetTeamNumber() ~= hero:GetTeamNumber() ) then
				v:AddNewModifier(hero, nil, "modifier_invisible", {})
			end
		  end
	  end
  
  end
  



  end
