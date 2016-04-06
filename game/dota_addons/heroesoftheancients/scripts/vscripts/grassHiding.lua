function bushStart(trigger)
  print('bush start')
  print(trigger.activator:GetClassname())

  local hero = trigger.activator
	hero:AddNewModifier(hero, nil, "modifier_invisible", {})

  if hero.IsRealHero and hero:IsRealHero()then
    hero.isInBushes = true
    if hero.canHideInBushes and not hero:HasModifier("modifier_bush_hiding") then
      ApplyModifier(hero, hero, "modifier_bush_hiding", {duration=hero.bushHideTime})
    end
  end
end

function bushEnd(trigger)
  print('bush end')
  print(trigger.activator:GetClassname())

  local hero = trigger.activator

  hero:RemoveModifierByName("modifier_invisible")

  
  if hero.IsRealHero and hero:IsRealHero() then
    hero.isInBushes = false
    Timers:CreateTimer(.2, function()
      if not hero.isInBushes then
        hero:RemoveModifierByName("modifier_bush_hiding")
      end
    end)


  end
end