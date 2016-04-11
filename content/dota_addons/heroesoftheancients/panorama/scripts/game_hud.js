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

var tbClass = "TimeBlue";
var tbName = "";
var tbActive = false;

var previousName = "";

var per = 0;

var minutes = "";
var seconds = "";


function TimeBar()
{
  var left = $("#TimeBarLeft");
  left.SetHasClass("TimeBlue", false);
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
	var perTeam1 = 0.1;
	var perTeam2 = 0.1;
	var perTeam1LvlFactor = 0.1;
	var perTeam2LvlFactor = 0.1;

function teamLevels(){

	//Set Levels


	if (Game.GetPlayerIDsOnTeam(2).length > 0){
		$("#teamLevel2").text = Players.GetLevel(Game.GetPlayerIDsOnTeam(2)[0]);
		
		var currentXP = Entities.GetCurrentXP(Players.GetPlayerHeroEntityIndex(Game.GetPlayerIDsOnTeam(2)[0]));
		var neededXP =	Entities.GetNeededXPToLevel(Players.GetPlayerHeroEntityIndex(Game.GetPlayerIDsOnTeam(2)[0]));
		
		//	$.Msg( neededXP - (neededXP - currentXP ) );
		
		currentXP -= perTeam1LvlFactor; 
		neededXP -= perTeam1LvlFactor; 
		
		perTeam1 = (currentXP * 100) / neededXP;
	}

	if (Game.GetPlayerIDsOnTeam(3).length > 0){
		$("#teamLevel3").text = Players.GetLevel(Game.GetPlayerIDsOnTeam(3)[0]);
		
		var currentXP = Entities.GetCurrentXP(Players.GetPlayerHeroEntityIndex(Game.GetPlayerIDsOnTeam(3)[0]));
		var neededXP =	Entities.GetNeededXPToLevel(Players.GetPlayerHeroEntityIndex(Game.GetPlayerIDsOnTeam(3)[0]));
		
		currentXP -= perTeam2LvlFactor; 
		neededXP -= perTeam2LvlFactor; 
		
		perTeam2 = (currentXP * 100) / neededXP;
	}
  
	//Set XP Bars
	
	
	var left1 = $("#xpbar1Left");
	  left1.SetHasClass("TimeBlue", true);
	  left1.SetHasClass("TimeRed", false);

	  left1.style.transition = "width 0.1s linear 0.0s;"
	  left1.style.width = perTeam1 * 1 + "px";
	  
	  	var left2 = $("#xpbar2Left");
	  left2.SetHasClass("TimeBlue", false);
	  left2.SetHasClass("TimeRed", true);

	  left2.style.transition = "width 0.1s linear 0.0s;"
	  left2.style.width = perTeam2 * 1 + "px";
  
  
  
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

	
	$.Schedule(1/10, checkFlipped);
}


function executeAbility(abilitySlotNumber) {
	Abilities.ExecuteAbility( Entities.GetAbility( Players.GetPlayerHeroEntityIndex( 0 ), abilitySlotNumber-1 ), Players.GetPlayerHeroEntityIndex( 0 ), false );
	
}

  var yourTeam = 0;
  var enemyTeam = 0;
	
function OnPlayerLevelUp( data ) {
	
	if (Game.GetPlayerIDsOnTeam(2).length > 0){

		if (data.PlayerID == Game.GetPlayerIDsOnTeam(2)[0]){
			var currentXP = Entities.GetCurrentXP(Players.GetPlayerHeroEntityIndex(Game.GetPlayerIDsOnTeam(2)[0]));
			var neededXP =	Entities.GetNeededXPToLevel(Players.GetPlayerHeroEntityIndex(Game.GetPlayerIDsOnTeam(2)[0]));
			
			perTeam1LvlFactor = ( neededXP - (neededXP - currentXP ) );
		}
	}
	if (Game.GetPlayerIDsOnTeam(3).length > 0){

		if (data.PlayerID == Game.GetPlayerIDsOnTeam(3)[0]){
			var currentXP = Entities.GetCurrentXP(Players.GetPlayerHeroEntityIndex(Game.GetPlayerIDsOnTeam(3)[0]));
			var neededXP =	Entities.GetNeededXPToLevel(Players.GetPlayerHeroEntityIndex(Game.GetPlayerIDsOnTeam(3)[0]));
			
			perTeam2LvlFactor = ( neededXP - (neededXP - currentXP ) );
		}
	}

}

function heroPanel(){


		var healPer = 	Entities.GetHealthPercent( Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer()) );

		var currentHealth = Entities.GetHealth(Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer()) );
		var maxHealth = Entities.GetMaxHealth( Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer()) );
		
	  	var left2 = $("#healthbarLeft");
	  left2.SetHasClass("TimeBlue", false);
	  left2.SetHasClass("TimeRed", true);

	  left2.style.transition = "width 0.1s linear 0.0s;"
	  left2.style.width = healPer + "%";

	  $("#healthbarText").text = currentHealth + " / " + maxHealth;
	  
	  // Mana
	  var maxMana = Entities.GetMaxMana( Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer()) );
	  var currentMana = Entities.GetMana( Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer()) );
	  
	  var manaPer = (currentMana * 100) / maxMana;
	  
	  var left1 = $("#manabarLeft");
	  left1.SetHasClass("TimeBlue", true);
	  left1.SetHasClass("TimeRed", false);

	  left1.style.transition = "width 0.1s linear 0.0s;"
	  left1.style.width = manaPer + "%";
	  
	  $("#manabarText").text = currentMana + " / " + maxMana;
	  
	$.Schedule(1/10, heroPanel);
}

function heroCamera(){
	
	
var unit = Entities.GetUnitName ( Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer()) );

var sceneContainer = $("#heroCam");

$("#HeroPortrait").heroname = unit;

}
	
(function(){

  yourTeam = Players.GetTeam(Players.GetLocalPlayer());

  if (yourTeam == 2){
	enemyTeam = 3;
  }
	
  else {
	enemyTeam = 2;
  }
  
  //Setup char camera 
  heroCamera();
  
  // capture bar
  TimeBar();

  heroPanel();
  
  //topBar
  showGameTime();
  teamLevels();
  
  showCustomCursor()
  
  checkFlipped()
  
  GameEvents.Subscribe("showCapturepoint", showCapturepoint);
  GameEvents.Subscribe("hideCapturepoint", hideCapturepoint); 

  CustomNetTables.SubscribeNetTableListener( "merc_capturepoints", capturePointsChanged );
  CustomNetTables.SubscribeNetTableListener( "watch_capturepoints", capturePointsChanged );
  
  GameEvents.Subscribe( "dota_player_gained_level", OnPlayerLevelUp );
  
})(); 
