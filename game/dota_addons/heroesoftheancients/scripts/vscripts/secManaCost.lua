local once = true
local otherOnce = true

function start( event )

	if (event.ability:GetToggleState()) then

		event.caster:SpendMana(event.mpPerSec, event.ability)
		
		if (event.caster:GetMana() < event.ability:GetManaCost( event.ability:GetLevel() ) )
		then
			event.ability:ToggleAbility()
		end
		
		if(otherOnce and event.caster.radarParticle == nil) then
			if (event.caster:GetTeam() == DOTA_TEAM_GOODGUYS)
			then
				event.caster.radarParticle = ParticleManager:CreateParticle("particles/radar_Blue.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.caster)
			else
				event.caster.radarParticle = ParticleManager:CreateParticle("particles/radar_Red.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.caster)
			end
		end
		
		once = true
		otherOnce = false
	else 
		if (event.caster.radarParticle and once) then
			ParticleManager:DestroyParticle(event.caster.radarParticle, false)
			event.caster.radarParticle = nil
			once = false
			otherOnce = true
		end

	end
end


