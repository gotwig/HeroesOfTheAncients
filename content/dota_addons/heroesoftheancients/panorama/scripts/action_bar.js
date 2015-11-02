"use strict";

function MakeAbilityPanel( abilityListPanel, ability, queryUnit )
{
	var abilityPanel = $.CreatePanel( "Panel", abilityListPanel, "" );
	abilityPanel.SetAttributeInt( "ability", ability );
	abilityPanel.SetAttributeInt( "queryUnit", queryUnit );
	abilityPanel.BLoadLayout( "file://{resources}/layout/custom_game/action_bar_ability.xml", false, false );
	
}

function UpdateAbilityList()
{
	var abilityListPanel = $( "#ability_list" );
	if ( !abilityListPanel )
		return;

	abilityListPanel.RemoveAndDeleteChildren();
	

	var queryUnit = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );
	
	for ( var i = 0; i < 15; ++i )
	{
		var ability = Entities.GetAbility( queryUnit, i );
		if ( ability == -1 )
			continue;

		// ignore all hidden ability
		if ( !Abilities.IsDisplayedAbility(ability) )
			continue;
		
		MakeAbilityPanel( abilityListPanel, ability, queryUnit );
	}
}

(function()
{
	GameEvents.Subscribe( "player_hero_first_spawn", UpdateAbilityList );
})();