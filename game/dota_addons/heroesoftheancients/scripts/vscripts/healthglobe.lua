function dropHealthGlobe(unit)
		if (unit:GetUnitName() == "npc_dota_creep_badguys_ranged_custom" or unit:GetUnitName() == "npc_dota_creep_goodguys_ranged_custom")
		then
			local item = nil
			
			if (unit:GetTeamNumber() == 2)
			then
				item = CreateItem("item_potion_of_healing_red", nil, nil)
			else
				item = CreateItem("item_potion_of_healing_blue", nil, nil)
			end

			local pos = unit:GetAbsOrigin()
			local drop = CreateItemOnPositionSync( pos, item )
			local pos_launch = pos+RandomVector(RandomFloat(150,200))
			item:LaunchLoot(true, 200, 0.75, pos_launch)

			Timers:CreateTimer( 30.0, function()
			if (drop)
			then
					UTIL_Remove(drop)
			end
					return nil
				end
			)
			
		end

end