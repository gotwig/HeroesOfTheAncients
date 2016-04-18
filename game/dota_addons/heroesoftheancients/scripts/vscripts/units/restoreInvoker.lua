function Mount(event )

	event.caster:RemoveAbility("lw_mountHorse")
	local newAbility = event.caster:AddAbility("invoker_ghost_walk")
	newAbility:SetLevel(1)
end

function Teleport(event )

	event.caster:RemoveAbility("lw_teleport")
	local newAbility = event.caster:AddAbility("invoker_ghost_walk")
	newAbility:SetLevel(1)
end