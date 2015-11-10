teamSkullPoints = {0, 0}

function dropSkull (unit)

	if (unit:GetUnitName() == "npc_dota_neutral_kobold")
	then
	 -- Create the item
    local item = CreateItem("item_skull", nil, nil)
    local pos = unit:GetAbsOrigin()
    local drop = CreateItemOnPositionSync( pos, item )
    local pos_launch = pos+RandomVector(RandomFloat(150,200))
    item:LaunchLoot(true, 200, 0.75, pos_launch)
	end
	
end

function summonGolems()
Say(nil, "Summon the skull golem!", false)

--teamSkullPoints[1] = 0
--teamSkullPoints[2] = 0
--hota:triggerMines(false)
end

function PickupSkull( event )

teamSkullPoints[event.unit:GetTeamNumber()-1] = teamSkullPoints[event.unit:GetTeamNumber()-1] + 1

if (teamSkullPoints[event.unit:GetTeamNumber()-1] >= 5)
then
summonGolems()
end


end

