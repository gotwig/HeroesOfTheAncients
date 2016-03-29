function FireSound( event )
	event.caster:EmitSound(event.sound_name)
end

function StopSound( event )
	event.caster:StopSound(event.sound_name)
end