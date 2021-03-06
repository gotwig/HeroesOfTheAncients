TeleportLocations = {
	mine_to_ug_top = "mineugtop",
	mine_to_ug_bot = "mineugbot",
	ug_to_mine_top = "minetop",
	ug_to_mine_bot = "minebot"
}

function Teleport(trigger)
	print ("You are coming from " .. trigger.caller:GetName())
	
	local hname = trigger.caller:GetName()
	local activatorPlayer = trigger.activator
	local new_position

	if TeleportLocations[hname] then new_position = Entities:FindByName(nil, TeleportLocations[hname])
	
	if (MINESOPEN or hname ==  "ug_to_mine_bot" or hname == "ug_to_mine_top")
	
	then
	activatorPlayer:Stop()	
	FindClearSpaceForUnit(activatorPlayer,new_position:GetAbsOrigin(),true)

	
		Timers:CreateTimer(
		function()
			PlayerResource:SetCameraTarget(activatorPlayer:GetPlayerID(), activatorPlayer)
			Timers:CreateTimer(0.1, 
				function()
				
					if (not activatorPlayer:GetPlayerOwner().lockCamera) then
						PlayerResource:SetCameraTarget(activatorPlayer:GetPlayerID(), nil)
					end
				end
			)
		end
	)
		

	end

	
	end
end