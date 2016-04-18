
function FireSound( event )
	event.caster:EmitSound(event.sound_name)
end

function FireSoundParams( event )
	event.caster:EmitSoundParams(event.sound_name, 1, 1.0, 2.0)
end

function StopSound( event )
	event.caster:StopSound(event.sound_name)
end