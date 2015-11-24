teamSkullPoints = {0, 0}

skullGolemKilled = 0

firstSkullGolemSpawn = true

skullunit_good = nil
skullunit_bad = nil

GameRules.point1_good = nil
GameRules.point2_good = nil

GameRules.siegeTop = {}
GameRules.siegeBot = {}

function deadTrigger (unit)

	if (MINESOPEN)
	then
		if (unit:GetUnitName() == "npc_dota_neutral_granite_golem")
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
	
	skullunit_good = CreateUnitByName("npc_dota_neutral_skull_golem", GameRules.point1_good, true, nil, nil, DOTA_TEAM_GOODGUYS)
	
	for i = 1,6 do
		ExecuteOrderFromTable({ UnitIndex = skullunit_good:GetEntityIndex(), OrderType =  DOTA_UNIT_ORDER_ATTACK_MOVE , Position = Entities:FindByName( nil, "lane_top_pathcorner_goodguys_" .. i ):GetAbsOrigin(), Queue = true})
	end

	skullunit_bad = CreateUnitByName("npc_dota_neutral_skull_golem", GameRules.point1_bad, true, nil, nil, DOTA_TEAM_BADGUYS)
	
	for i = 1,6 do
		ExecuteOrderFromTable({ UnitIndex = skullunit_good:GetEntityIndex(), OrderType =  DOTA_UNIT_ORDER_ATTACK_MOVE , Position = Entities:FindByName( nil, "lane_top_pathcorner_badguys_" .. i ):GetAbsOrigin(), Queue = true})
	end


for key,value in pairs(Entities:FindAllByModel("models/creeps/neutral_creeps/n_creep_kobold/kobold_c/n_creep_kobold_c.vmdl"))
do
	  value:ForceKill(false)
end

Entities:FindByModel(nil,"models/creeps/neutral_creeps/n_creep_golem_a/neutral_creep_golem_a.vmdl"):ForceKill(false)


end

function PickupSkull( event )

teamSkullPoints[event.unit:GetTeamNumber()-1] = teamSkullPoints[event.unit:GetTeamNumber()-1] + 1

if (teamSkullPoints[event.unit:GetTeamNumber()-1] >= 10)
then
summonGolems()
end


end

