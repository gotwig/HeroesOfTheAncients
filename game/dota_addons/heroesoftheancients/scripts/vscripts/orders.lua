function hota:MoonWellOrder( event )
    local pID = event.pID
    local entityIndex = event.mainSelected
    local target = EntIndexToHScript(entityIndex)
    local targetIndex = event.targetIndex
    local moon_well = EntIndexToHScript(targetIndex)

    local replenish = moon_well:FindAbilityByName("nightelf_replenish_mana_and_life")
    moon_well:CastAbilityOnTarget(target, replenish, moon_well:GetPlayerOwnerID())
end

