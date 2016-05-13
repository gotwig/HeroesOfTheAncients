function start( event )
	event.caster:SpendMana(event.mpPerSec, event.ability)
	
	if (event.caster:GetMana() < event.ability:GetManaCost( event.ability:GetLevel() ) )
	then
		event.ability:ToggleAbility()
	end
	
end