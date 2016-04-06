"use strict";

function flipMinimap(){
	$.Msg( "Flipping Minimap" );
	var iPlayerid = Players.GetLocalPlayer();
	GameEvents.SendCustomGameEventToServer( "flipMinimap", { pID: iPlayerid })
}

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

var minutes = "";
var seconds = "";


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

function showGameTime(){
  minutes = Math.floor(Game.GetDOTATime( true, false)/60);
  seconds = Math.floor(Game.GetDOTATime( true, false) % 60); 
    
  if (minutes < 10) {
	  minutes = "0" + minutes;
  }
  
 if (seconds < 10) {
	  seconds = "0" + seconds;
  }
  
  $("#timeGameMinutes").text = minutes + ":";
  $("#timeGameSeconds").text = seconds;
  
  $.Schedule(1/10, showGameTime);
}

function teamLevels(){
	

	if (Game.GetPlayerIDsOnTeam(2).length > 0){
		$("#teamLevel2").text = Players.GetLevel(Game.GetPlayerIDsOnTeam(2)[0]);
	}

	if (Game.GetPlayerIDsOnTeam(3).length > 0){
		$("#teamLevel3").text = Players.GetLevel(Game.GetPlayerIDsOnTeam(3)[0]);
	}
  
	$.Schedule(1/10, teamLevels);
}



function showCustomCursor(){
	$("#cursorImage").style["position"] = GameUI.GetCursorPosition()[0] + "px " + GameUI.GetCursorPosition()[1] + "px 0px;" 
		
		
	if (GameUI.FindScreenEntities( GameUI.GetCursorPosition() )[0]){
		if ( Entities.GetTeamNumber(GameUI.FindScreenEntities( GameUI.GetCursorPosition() )[0].entityIndex) == yourTeam ){
			$("#cursorImage").style["background-image"] = 'url("file://{images}/custom_game/hud/cursors/cursor_ally.png");';
		}
		
		if ( Entities.GetTeamNumber(GameUI.FindScreenEntities( GameUI.GetCursorPosition() )[0].entityIndex) == enemyTeam){
			$("#cursorImage").style["background-image"] = 'url("file://{images}/custom_game/hud/cursors/cursor_enemy.png");';
		}
	}
	
	else {
		$("#cursorImage").style["background-image"] = 'url("file://{images}/custom_game/hud/cursors/cursor.png");'; 
	}
	
	$.Schedule(1/1000, showCustomCursor);
}

function checkFlipped(){
	if (Game.IsHUDFlipped()){
		$("#TimersPanel").style["horizontal-align"] = "left;";
	}
	else {		
		$("#TimersPanel").style["horizontal-align"] = "right;";
	}

	$.Schedule(1/10, checkFlipped);
}

function initAbilities(){
		
	var abilityBar = $("#abilities");
	
}

function executeAbility(abilitySlotNumber) {
	Abilities.ExecuteAbility( Entities.GetAbility( Players.GetPlayerHeroEntityIndex( 0 ), abilitySlotNumber-1 ), Players.GetPlayerHeroEntityIndex( 0 ), false );
	
}

  var yourTeam = 0;
  var enemyTeam = 0;
	
	
(function(){

  yourTeam = Players.GetTeam(Players.GetLocalPlayer());

  if (yourTeam == 2){
	enemyTeam = 3;
  }
	
  else {
	enemyTeam = 2;
  }

  
  // capture bar
  TimeBar();
  
  //topBar
  showGameTime();
  teamLevels();
  
  showCustomCursor()
  
  checkFlipped()
  
  GameEvents.Subscribe("showCapturepoint", showCapturepoint);
  GameEvents.Subscribe("hideCapturepoint", hideCapturepoint); 

  CustomNetTables.SubscribeNetTableListener( "merc_capturepoints", capturePointsChanged );
  CustomNetTables.SubscribeNetTableListener( "watch_capturepoints", capturePointsChanged );
  
})(); 
