function Replenish( event )
	local moon_well = event.caster
	local ability = event.ability
	local target = event.target

	local current_mana = moon_well:GetMana()
	local hp_per_mana = ability:GetSpecialValueFor("hp_per_mana")
	local mp_per_mana = ability:GetSpecialValueFor("mp_per_mana")

	local missing_hp = target:GetHealthDeficit()
	local missing_mana = target:GetMaxMana() - target:GetMana()

	-- Don't ever cast on full health and mana
	if missing_hp == 0 and missing_mana == 0 then
		return
	end

	-- Best effort to fully replenish the unit
	local replenish_life = 0
	local replenish_mana = 0

	local mana_needed = missing_hp / hp_per_mana + missing_mana / mp_per_mana

	-- If it can be fully healed, do so
	if  mana_needed <= current_mana then
		replenish_life = missing_hp
		replenish_mana = missing_mana
	else
		-- Use mana in equal parts
		mana_needed = current_mana
		current_mana = current_mana / 2
		replenish_life = current_mana * hp_per_mana
		replenish_mana = current_mana * mp_per_mana
	end

	target:Heal(replenish_life, moon_well)
	target:GiveMana(replenish_mana)

	if mana_needed > 0 then
		moon_well:SpendMana(mana_needed, ability)

		--print("Replenished ",target:GetUnitName()," for "..replenish_life.." HP and "..replenish_mana.." MP")

		ParticleManager:CreateParticle("particles/items3_fx/mango_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, moon_well)
		target:EmitSound("DOTA_Item.Mango.Activate")
	end

end


