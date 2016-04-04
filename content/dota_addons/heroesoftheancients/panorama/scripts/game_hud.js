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

var tbClass = "TimeGreen";
var tbName = "";
var tbActive = false;

var previousName = "";

var per = 0;

function TimeBar()
{
  var left = $("#TimeBarLeft");
  left.SetHasClass("TimePurple", false);
  left.SetHasClass("TimeYellow", false);
  left.SetHasClass("TimeRed", false);
  left.SetHasClass(tbClass, true);

  $("#TimeBar").visible = tbActive;

  if (tbActive){
    left.style.transition = "width 0.1s linear 0.0s;"
    

	
    left.style.width = per * 2.4 + "px";
    $("#TimeName").text = tbName;
  }
  $.Schedule(1/10, TimeBar);
}

function showCapturepoint(msg)
{  
  previousName = msg.name;
  tbActive = true;
}

function hideCapturepoint(msg)
{
  if (msg.name == previousName){
	tbActive = false;
  }
  
}

function capturePointsChanged( table_name, key, data )
{
	if (previousName == key ){ 
		per = data.value;
	}
}

(function(){
  TimeBar();

  GameEvents.Subscribe("showCapturepoint", showCapturepoint);
  GameEvents.Subscribe("hideCapturepoint", hideCapturepoint); 

  CustomNetTables.SubscribeNetTableListener( "merc_capturepoints", capturePointsChanged );
  CustomNetTables.SubscribeNetTableListener( "watch_capturepoints", capturePointsChanged );
  
})(); 
