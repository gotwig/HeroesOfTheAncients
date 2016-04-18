function MountHorse( event )

    local caster = event.caster
	
	caster:Stop()
	
	if ( caster:HasItemInInventory("item_boots_of_riding") )
		then
			local item = caster:GetItemInSlot(2)
			caster:RemoveItem(item)
		else
			caster:AddItemByName("item_boots_of_riding")
	end


end

function Dismount( event )

    local caster = event.caster
	
	if ( caster:HasItemInInventory("item_boots_of_riding") )
		then
			local item = caster:GetItemInSlot(2)
			caster:RemoveItem(item)
			caster:Interrupt()
			caster:EmitSound("Courier.Footsteps")
	end

end