

function onMercenaryDead(unit)
		if (unit:GetUnitName() == "stuff")
		then

			local item = CreateItem("item_flask", nil, nil)
			local pos = unit:GetAbsOrigin()
			local drop = CreateItemOnPositionSync( pos, item )
			local pos_launch = pos+RandomVector(RandomFloat(150,200))
			item:LaunchLoot(true, 200, 0.75, pos_launch)

			Timers:CreateTimer( 390.0, function()
					skullunit_bad = CreateUnitByName("npc_dota_neutral_skull_golem", POINT, true, nil, nil, DOTA_TEAM_NEUTRALS)
			
					return nil
				end
			)
			
		end

end