function stop ( event )

if (event.caster:GetForwardVector() ~= event.caster.rotateVector) then
	event.caster:SetForwardVector (event.caster.rotateVector)
end

end