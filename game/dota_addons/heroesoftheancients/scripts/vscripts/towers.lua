require('libraries/timers')


customTowers = {}

function initTowers()


end

function initShots( event )
	local caster = event.caster
	
	caster.maxShots = 20
	
	if (caster:GetUnitName() == "keep")
	then
		caster.maxShots = 40
	end
	
	caster.remainingShots = caster.maxShots 
	caster.once = true
	
	CustomNetTables:SetTableValue( "tower_ammoPoints", " " .. caster:GetEntityIndex() , { value = caster.remainingShots } )

end

function thinkShots( event )
	local caster = event.caster
	
	if (caster.remainingShots > 0)
	then
		caster:RemoveModifierByName("modifier_disarmed")
	end
	
	if (caster.once)
	then
		Timers:CreateTimer( 30, function()
			caster.remainingShots = caster.remainingShots + 2
			
			if (caster.remainingShots >= caster.maxShots)
			then
				caster.remainingShots = caster.maxShots
			end
			
			caster.once = true
			CustomNetTables:SetTableValue( "tower_ammoPoints", " " .. caster:GetEntityIndex() , { value = caster.remainingShots } )

			
		end
		)
	caster.once = false
	
	end
	
end

function ShotFired( event )
	local caster = event.caster
	
	caster.remainingShots = caster.remainingShots - 1
	
	CustomNetTables:SetTableValue( "tower_ammoPoints", " " .. caster:GetEntityIndex() , { value = caster.remainingShots } )
	
	if (caster.remainingShots < 1)
	then
		caster:AddNewModifier(caster, nil, "modifier_disarmed", {})
	end
end