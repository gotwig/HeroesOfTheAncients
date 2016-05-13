function showRadar(event)

if (event.caster:GetTeam() == DOTA_TEAM_GOODGUYS)
then
	event.caster.radarParticle = ParticleManager:CreateParticle("particles/radar_Blue.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.caster)
else
	event.caster.radarParticle = ParticleManager:CreateParticle("particles/radar_Red.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.caster)
end




end

function destroyRadar(event)
ParticleManager:DestroyParticle(event.caster.radarParticle, false)

end