function destroyedKeep(unit)

	if (unit:GetUnitName() == "keep")
		then
			print (unit:GetName()[string.len(unit:GetName())-1] )
			if (unit:GetTeamNumber() == 2 )
			then
			teamnumber = 3
			teamselection = "bad"
			
			end
			
			if (unit:GetTeamNumber() == 3 )
			then
			teamnumber = 2
			teamselection = "good"

			end
			
			if ((unit:GetName()):sub(string.len(unit:GetName()) - 4, string.len(unit:GetName()) - 2) == "top")
			then
			print ("TOP")
			GameRules.siegeTop[teamselection] = true
			end
			
			if ((unit:GetName()):sub(string.len(unit:GetName()) - 4, string.len(unit:GetName()) - 2) == "bot")
			then
			GameRules.siegeBot[teamselection] = true
			end


						

		end
end	