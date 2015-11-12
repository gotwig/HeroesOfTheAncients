teamSkullPoints = {0, 0}


skullGolemKilled = 0

firstSkullGolemSpawn = true

skullunit_good = nil
skullunit_bad = nil

GameRules.point1_good = nil
GameRules.point2_good = nil

function deadTrigger (unit)
	if (MINESOPEN)
	then
		if (unit:GetUnitName() == "npc_dota_neutral_rock_golem")
		then

			for i = 0, 33, 1 do
					local item = CreateItem("item_skull", nil, nil)
					local pos = unit:GetAbsOrigin()
					local drop = CreateItemOnPositionSync( pos, item )
					local pos_launch = pos+RandomVector(RandomFloat(150,200))
					item:LaunchLoot(true, 200, 0.75, pos_launch)
			end
		
		end
		
		if (unit:GetUnitName() == "npc_dota_neutral_kobold")
		then
		
		for i = 0, 1, 1 do
				local item = CreateItem("item_skull", nil, nil)
				local pos = unit:GetAbsOrigin()
				local drop = CreateItemOnPositionSync( pos, item )
				local pos_launch = pos+RandomVector(RandomFloat(150,200))
				item:LaunchLoot(true, 200, 0.75, pos_launch)
		end

		end
	
	end

	
	
	if (unit:GetUnitName() == "npc_dota_neutral_skull_golem")
	then

	if (unit:GetTeamNumber() == 2 )
	then 

	GameRules.point1_good = unit:GetAbsOrigin()

	
	
	end
	
	if (unit:GetTeamNumber() == 3 )
	then
	GameRules.point1_bad = unit:GetAbsOrigin()

	end
	
	skullGolemKilled = skullGolemKilled + 1
	print ("killed")
		if (skullGolemKilled >= 2)
			then
			skullGolemKilled = 0
			
			Timers:CreateTimer( 120.0, function()
					hota:triggerMines(true)
				end
			)

		end
	
	end
	
end

function summonGolems()
teamSkullPoints[1] = 0
teamSkullPoints[2] = 0
hota:triggerMines(false)


if (firstSkullGolemSpawn)
then
	
	GameRules.point1_good = Entities:FindByName( nil, "skullGolemSpawn_good"):GetAbsOrigin()
	
	GameRules.point1_bad = Entities:FindByName( nil, "skullGolemSpawn_bad"):GetAbsOrigin()

	firstSkullGolemSpawn = false
end

	local wp1 = Entities:FindByName( nil, "lane_mid_pathcorner_goodguys_6"):GetAbsOrigin()


	skullunit_good = CreateUnitByName("npc_dota_neutral_skull_golem", GameRules.point1_good, true, nil, nil, DOTA_TEAM_GOODGUYS)
	ExecuteOrderFromTable({ UnitIndex = skullunit_good:GetEntityIndex(), OrderType =  DOTA_UNIT_ORDER_ATTACK_MOVE , Position = wp1, Queue = true})

	local wp1 = Entities:FindByName( nil, "lane_mid_pathcorner_badguys_6"):GetAbsOrigin()

	skullunit_bad = CreateUnitByName("npc_dota_neutral_skull_golem", GameRules.point1_bad, true, nil, nil, DOTA_TEAM_BADGUYS)
	ExecuteOrderFromTable({ UnitIndex = skullunit_bad:GetEntityIndex(), OrderType =  DOTA_UNIT_ORDER_ATTACK_MOVE , Position = wp1, Queue = true})



for key,value in pairs(Entities:FindAllByModel("models/creeps/neutral_creeps/n_creep_kobold/kobold_c/n_creep_kobold_c.vmdl"))
do
	  print ("summon golem")
	  value:ForceKill(false)
	
end


end

function PickupSkull( event )

teamSkullPoints[event.unit:GetTeamNumber()-1] = teamSkullPoints[event.unit:GetTeamNumber()-1] + 1

if (teamSkullPoints[event.unit:GetTeamNumber()-1] >= 10)
then
summonGolems()
end


end

