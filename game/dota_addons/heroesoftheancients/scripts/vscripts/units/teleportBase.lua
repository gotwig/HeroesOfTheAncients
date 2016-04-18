function Teleport( event )

    local caster = event.caster
	
	if (caster:GetTeamNumber() == 2)
	then
	FindClearSpaceForUnit(caster,Entities:FindByName( nil, "start_good"):GetAbsOrigin(),true)
	else if (caster:GetTeamNumber() == 3)
	then
	FindClearSpaceForUnit(caster,Entities:FindByName( nil, "start_bad"):GetAbsOrigin(),true)
	end
	end
	
	caster:Stop()
	
	PlayerResource:SetCameraTarget(event.caster:GetPlayerID(), event.caster)
	
	Timers:CreateTimer(0.1, 
	function()
		PlayerResource:SetCameraTarget(event.caster:GetPlayerID(), nil)
		end
	)
	
	if ( not caster:HasItemInInventory("item_boots_of_riding") )
		then
			caster:AddItemByName("item_boots_of_riding")
	end


end