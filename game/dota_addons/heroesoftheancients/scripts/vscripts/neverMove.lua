function neverMove( event )
	event.caster:SetNeverMoveToClearSpace(true)
	
	event.caster.rotateVector = event.caster:GetForwardVector()
	
end