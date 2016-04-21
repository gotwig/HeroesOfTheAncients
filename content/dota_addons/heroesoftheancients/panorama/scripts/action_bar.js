"use strict";

var m_AbilityPanels = []; // created up to a high-water mark, but reused when selection changes

function teleportBase(){
	$.Msg( "trigger teleport back to base event" );
	
	var ent = Players.GetLocalPlayerPortraitUnit();
	
	if (Entities.IsControllableByPlayer( ent, Players.GetLocalPlayer() )){
		GameEvents.SendCustomGameEventToServer( "teleportBase", { entID: ent })
	
	}
	

}

function mountHorse(){
	$.Msg( "Mount the horse" );
	var iPlayerid = Players.GetLocalPlayer();
	
	var ent = Players.GetLocalPlayerPortraitUnit();
	
	if (Entities.IsControllableByPlayer( ent, Players.GetLocalPlayer() )){
		GameEvents.SendCustomGameEventToServer( "mountHorse", { entID: ent })
	
	}
}

function OnLevelUpClicked()
{
	if ( Game.IsInAbilityLearnMode() )
	{
		Game.EndAbilityLearnMode();
	}
	else
	{
		Game.EnterAbilityLearnMode();
	}
}

function OnAbilityLearnModeToggled( bEnabled )
{
	UpdateAbilityList();
}

function UpdateAbilityList()
{
	
	var abilityListPanel = $( "#ability_list" );
	if ( !abilityListPanel )
		return;

	var queryUnit = Players.GetLocalPlayerPortraitUnit();

	// see if we can level up
	var nRemainingPoints = Entities.GetAbilityPoints( queryUnit );
	var bPointsToSpend = ( nRemainingPoints > 0 );
	var bControlsUnit = Entities.IsControllableByPlayer( queryUnit, Game.GetLocalPlayerID() );
	$.GetContextPanel().SetHasClass( "could_level_up", ( bControlsUnit && bPointsToSpend ) );

	// update all the panels
	var nUsedPanels = 0;
	for ( var i = 0; i < Entities.GetAbilityCount( queryUnit ); ++i )
	{
		var ability = Entities.GetAbility( queryUnit, i );
		if ( ability == -1 )
			continue;

		if ( !Abilities.IsDisplayedAbility(ability) )
			continue;
		
		if ( nUsedPanels >= m_AbilityPanels.length )
		{
			// create a new panel
			var abilityPanel = $.CreatePanel( "Panel", abilityListPanel, "" );
			abilityPanel.BLoadLayout( "file://{resources}/layout/custom_game/action_bar_ability.xml", false, false );
			m_AbilityPanels.push( abilityPanel );
		}

		// update the panel for the current unit / ability
		var abilityPanel = m_AbilityPanels[ nUsedPanels ];
		abilityPanel.SetAbility( ability, queryUnit, Game.IsInAbilityLearnMode() );
		
		nUsedPanels++;
	}

	// clear any remaining panels
	for ( var i = nUsedPanels; i < m_AbilityPanels.length; ++i )
	{
		var abilityPanel = m_AbilityPanels[ i ];
		abilityPanel.SetAbility( -1, -1, false );
	}
	if (nUsedPanels > 0) {
		$.GetContextPanel().visible = true;
	} else {
		$.GetContextPanel().visible = false;
	}
	
}

(function()
{

	GameEvents.Subscribe( "dota_portrait_ability_layout_changed", UpdateAbilityList );
	GameEvents.Subscribe( "dota_player_update_selected_unit", UpdateAbilityList );
	GameEvents.Subscribe( "dota_player_update_query_unit", UpdateAbilityList );
	GameEvents.Subscribe( "dota_ability_changed", UpdateAbilityList );
	GameEvents.Subscribe( "dota_hero_ability_points_changed", UpdateAbilityList );
	
	UpdateAbilityList(); // initial update
	
	Game.AddCommand( "+AbilityTeleportTrigger", teleportBase, "", 0 );
    Game.AddCommand( "+AbilityMountTrigger", mountHorse, "", 0 );
	
})();

