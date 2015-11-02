"use strict";

function heroCamLock(){
	$.Msg( "Switching hero cam lock ON/OFF" );
	var iPlayerid = Players.GetLocalPlayer();
	GameEvents.SendCustomGameEventToServer( "lockCameraToHero", { pID: iPlayerid })
}