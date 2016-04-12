teamSkullPoints = {0, 0}

skullGolemKilled = 0

firstSkullGolemSpawn = true

skullunit_good = nil
skullunit_bad = nil

GameRules.point1_good = nil
GameRules.point2_good = nil

GameRules.siegeTop = {}
GameRules.siegeBot = {}

require ('libraries/notifications')

golemssummontexts = {'Break free and destroy your enemies!','Let my golems rise again!','Now is the hour of my golems return.','Rise again, my golems, and unleash your boundless anger!','Rise golems! Rise and let loose your wrath!'}
golemsdefeatedtexts = {'And so, the bone golems fall. Dust to dust, as they say.','It seems my golems return to the earth. For now.','My golems have fallen. No matter, there are always more skulls to be had.','The golems have been defeated.','The golems will return, heroes.'}

minesopenwarningtexts = {'Are you prepared to fight the undead? The mines shall open shortly.','Death stirs within the mines... Shall you brave the darkness?','Listen, heroes... The undead shall rise within the mines shortly.','The damned shall soon return. Prepare yourselves, heroes.','The dead rise again, heroes. Dare you enter the mines?','The mines will open shortly, heroes... soon the undead will awaken.'}

function deadTrigger (unit)

	if (MINESOPEN)
	then
		if (unit:GetUnitName() == "npc_dota_neutral_granite_golem")
		then

			for i = 0, 37, 1 do
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
	
		if (skullGolemKilled >= 2)
			then
			skullGolemKilled = 0
			
			Notifications:TopToAll({text=golemsdefeatedtexts[RandomInt( 1, #golemsdefeatedtexts )], duration=10.0})
			
			Timers:CreateTimer( 90.0, function()
					Notifications:TopToAll({text=minesopenwarningtexts[RandomInt( 1, #minesopenwarningtexts )], duration=10.0})
					
					Timers:CreateTimer( 30.0, function()
							hota:triggerMines(true)
						end
					)
				end
			)
			
			
			



		end
	
	end
	
end

function summonGolems()

Notifications:TopToAll({text=golemssummontexts[RandomInt( 1, #golemssummontexts )], duration=10.0})


if (firstSkullGolemSpawn)
then
	
	GameRules.point1_good = Entities:FindByName( nil, "skullGolemSpawn_good"):GetAbsOrigin()
	
	GameRules.point1_bad = Entities:FindByName( nil, "skullGolemSpawn_bad"):GetAbsOrigin()

	firstSkullGolemSpawn = false
end
	
	if (Entities:FindByModel(nil,"models/creeps/neutral_creeps/n_creep_golem_a/neutral_creep_golem_a.vmdl"))
	then
		Entities:FindByModel(nil,"models/creeps/neutral_creeps/n_creep_golem_a/neutral_creep_golem_a.vmdl"):ForceKill(false)
	end
	
	skullunit_good = CreateUnitByName("npc_dota_neutral_skull_golem", GameRules.point1_good, true, nil, nil, DOTA_TEAM_GOODGUYS)
	
	skullunit_good:SetMaxHealth((skullunit_good:GetMaxHealth() / 100 * 20) + (skullunit_good:GetMaxHealth() / 100 * teamSkullPoints[1]))
	
	for i = 1,6 do
		ExecuteOrderFromTable({ UnitIndex = skullunit_good:GetEntityIndex(), OrderType =  DOTA_UNIT_ORDER_ATTACK_MOVE , Position = Entities:FindByName( nil, "lane_top_pathcorner_goodguys_" .. i ):GetAbsOrigin(), Queue = true})
	end

	skullunit_bad = CreateUnitByName("npc_dota_neutral_skull_golem", GameRules.point1_bad, true, nil, nil, DOTA_TEAM_BADGUYS)
	
	skullunit_bad:SetMaxHealth((skullunit_bad:GetMaxHealth() / 100 * 20) + (skullunit_bad:GetMaxHealth() / 100 * teamSkullPoints[2]))
	
	for i = 1,6 do
		ExecuteOrderFromTable({ UnitIndex = skullunit_bad:GetEntityIndex(), OrderType =  DOTA_UNIT_ORDER_ATTACK_MOVE , Position = Entities:FindByName( nil, "lane_top_pathcorner_badguys_" .. i ):GetAbsOrigin(), Queue = true})
	end

teamSkullPoints[1] = 0
teamSkullPoints[2] = 0

hota:triggerMines(false)

for key,value in pairs(Entities:FindAllByModel("models/creeps/neutral_creeps/n_creep_kobold/kobold_c/n_creep_kobold_c.vmdl"))
do
	  value:ForceKill(false)
end


end

function PickupSkull( event )

teamSkullPoints[event.unit:GetTeamNumber()-1] = teamSkullPoints[event.unit:GetTeamNumber()-1] + 1

CustomNetTables:SetTableValue( "dynamic_MapEvents", "dynamic_event" , { team1 = teamSkullPoints[1], team2 = teamSkullPoints[2], remaining = (100 - (teamSkullPoints[1] + teamSkullPoints[2]))} )


print (teamSkullPoints[1])

if (teamSkullPoints[1] + teamSkullPoints[2] >= 100)
then
summonGolems()
end


end

