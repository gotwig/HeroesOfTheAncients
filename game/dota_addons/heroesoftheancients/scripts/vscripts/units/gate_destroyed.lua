function onGateDeath(unit)

	if (unit:GetUnitName() == "gate" )
		then
			Physics:RemoveCollider(unit:GetName())
			
			
			local decoEntities = Entities:FindAllByName(unit:GetName() .. "_deco")
			for key,value in pairs(decoEntities) do
					value:RemoveSelf()
			end
		end
end	