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

golemssummontexts = {'Break free and crush your enemies!'}
golemsdefeatedtexts = {'And so the bones fall...'}

minesopenwarningtexts = {'Are you prepared to fight the undead? The mines open shortly.'}

function deadTrigger (unit)

	if (MINESOPEN)
	then
		if (unit:GetUnitName() == "npc_dota_neutral_skull_golem")
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

	
	
	if (unit:GetUnitName() == "npc_dota_neutral_skull_golem_summoned")
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
EmitAnnouncerSound("announcer_ann_custom_generic_alert_16")	

	Timers:CreateTimer({
				useGameTime = false,
				endTime = 5, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
				callback = function()
					EmitAnnouncerSoundForTeam("announcer_ann_custom_generic_alert_48", 2)
					EmitAnnouncerSoundForTeam("announcer_ann_custom_generic_alert_44", 3)
				end
	})

if (firstSkullGolemSpawn)
then
	
	GameRules.point1_good = Entities:FindByName( nil, "skullGolemSpawn_good"):GetAbsOrigin()
	
	GameRules.point1_bad = Entities:FindByName( nil, "skullGolemSpawn_bad"):GetAbsOrigin()

	firstSkullGolemSpawn = false
end
	
	if (Entities:FindByModel(nil,"models/creeps/lane_creeps/creep_dire_hulk/creep_dire_ancient_hulk.vmdl"))
	then
		Entities:FindByModel(nil,"models/creeps/lane_creeps/creep_dire_hulk/creep_dire_ancient_hulk.vmdl"):ForceKill(false)
	end
	
	skullunit_good = CreateUnitByName("npc_dota_neutral_skull_golem_summoned", GameRules.point1_good, true, nil, nil, DOTA_TEAM_GOODGUYS)
	
	skullunit_good:SetMaxHealth((skullunit_good:GetMaxHealth() / 100 * 20) + (skullunit_good:GetMaxHealth() / 100 * teamSkullPoints[1]))
	
	ExecuteOrderFromTable({ UnitIndex = skullunit_good:GetEntityIndex(), OrderType =  DOTA_UNIT_ORDER_ATTACK_MOVE , Position = Entities:FindByName( nil, "lane_top_pathcorner_goodguys_" .. 6 ):GetAbsOrigin(), Queue = true})

	skullunit_bad = CreateUnitByName("npc_dota_neutral_skull_golem_summoned", GameRules.point1_bad, true, nil, nil, DOTA_TEAM_BADGUYS)
	
	skullunit_bad:SetMaxHealth((skullunit_bad:GetMaxHealth() / 100 * 20) + (skullunit_bad:GetMaxHealth() / 100 * teamSkullPoints[2]))
	
	ExecuteOrderFromTable({ UnitIndex = skullunit_bad:GetEntityIndex(), OrderType =  DOTA_UNIT_ORDER_ATTACK_MOVE , Position = Entities:FindByName( nil, "lane_bot_pathcorner_badguys_" .. 4 ):GetAbsOrigin(), Queue = true})

hota:triggerMines(false)

for key,value in pairs(Entities:FindAllByModel("models/creeps/neutral_creeps/n_creep_kobold/kobold_c/n_creep_kobold_c.vmdl"))
do
	  value:ForceKill(false)
end

teamSkullPoints[1] = 0
teamSkullPoints[2] = 0

CustomNetTables:SetTableValue( "dynamic_MapEvents", "dynamic_event" , { team1 = teamSkullPoints[1], team2 = teamSkullPoints[2], remaining = (100 - (teamSkullPoints[1] + teamSkullPoints[2]))} )

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

