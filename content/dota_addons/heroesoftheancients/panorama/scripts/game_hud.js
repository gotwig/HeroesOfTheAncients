"use strict";

function heroCamLock(){
	$.Msg( "Switching hero cam lock ON/OFF" );
	var iPlayerid = Players.GetLocalPlayer();
	GameEvents.SendCustomGameEventToServer( "lockCameraToHero", { pID: iPlayerid })
}

function teleportBase(){
	$.Msg( "trigger teleport back to base event" );
	var iPlayerid = Players.GetLocalPlayer();
	//$.Msg(Entities.GetAbilityByName( Players.GetPlayerHeroEntityIndex( 0 ) , "lw_teleport" )   );
	//Abilities.ExecuteAbility( Entities.GetAbilityByName( Players.GetPlayerHeroEntityIndex( 0 ) , "lw_teleport" ), Players.GetPlayerHeroEntityIndex( 0 ), true )
	GameEvents.SendCustomGameEventToServer( "teleportBase", { pID: iPlayerid })
}