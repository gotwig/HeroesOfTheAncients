"use strict";

function flipMinimap(){
	$.Msg( "Flipping Minimap" );
	var iPlayerid = Players.GetLocalPlayer();
	GameEvents.SendCustomGameEventToServer( "flipMinimap", { pID: iPlayerid })
}

function heroCamLock(){
	$.Msg( "Switching hero cam lock ON/OFF" );

	
	var iPlayerid = Players.GetLocalPlayer();
	var entityID = Players.GetLocalPlayerPortraitUnit();
	GameEvents.SendCustomGameEventToServer( "lockCameraToHero", { pID: iPlayerid, entID: entityID })
}

var tbClass = "TimeBlue";
var tbName = "";
var tbActive = false;

var previousName = "";

var per = 0;

var minutes = "";
var seconds = "";

var deathMaxTime = 0;
var showDeathTimebar = false;
var initShowDeath = false;

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

function heroDeathTimebar()
{

	  if (Players.GetRespawnSeconds ( Players.GetLocalPlayer()) < 0){
		  showDeathTimebar = false;
	  }
	  
	  if (Players.GetRespawnSeconds ( Players.GetLocalPlayer()) > 0 && initShowDeath){
		  deathMaxTime = Players.GetRespawnSeconds ( Players.GetLocalPlayer() )

		  initShowDeath = false;
	  }
	  

	  if (showDeathTimebar){

		  var leftDeath = $("#DeathTimeBarLeft");
		  leftDeath.SetHasClass("TimeBlue", false);
		  leftDeath.SetHasClass("TimeRed", false);
		  leftDeath.SetHasClass(tbClass, true);

		  $("#DeathTimeBar").visible = true ;

		  leftDeath.style.transition = "width 0.01s linear 0.0s;"
		
		
		  $("#HeroRespawnTime").text = Players.GetRespawnSeconds ( Players.GetLocalPlayer());

		leftDeath.style.width = ((Players.GetRespawnSeconds ( Players.GetLocalPlayer()) / deathMaxTime) * 100) * 2.4 + "px";
		}
	  
	  else {
		$("#DeathTimeBar").visible = false;
	  }
	
  $.Schedule(1/1000, heroDeathTimebar);
}

function initDeath(){
	showDeathTimebar = true;
}

function OnHeroDeath(data){
	if (data.entindex_killed == Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ) ){
		$.Msg( "Your Hero Died" );
		
		initShowDeath = true;

		$.Schedule(1, initDeath);

		
	}
}

function OnHeroRespawn(data){
	if (data.entindex == Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ) ){
		$.Msg( "Your Hero Respawned" );
	}
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
  minutes = Math.floor(Game.GetDOTATime( false, false)/60);
  seconds = Math.floor(Game.GetDOTATime( false, true) % 60); 
    
  if (minutes < 10) {
	  minutes = "0" + minutes;
  }
  
  
  if (minutes > -1 && seconds > 0){
  $("#timeGameMinutes").text = minutes + ":";
	  if (seconds < 10) {
		  seconds = "0" + seconds;
	  }
  }
  
  $("#timeGameSeconds").text = seconds;
  
  $.Schedule(1/10, showGameTime);
}

function dynamicEventInfoChanged( table_name, key, data )
{
	$.Msg( "Table ", table_name, " changed: '", key, "' = ", data );

	$("#mapEventInfoTeam2").text = data.team1;
	$("#mapEventInfoTeam3").text = data.team2;
	$("#mapEventInfoRemaining").text =  data.remaining;
}

	var perTeam1 = 0.1;
	var perTeam2 = 0.1;
	var perTeam1LvlFactor = 0.1;
	var perTeam2LvlFactor = 0.1;

function teamLevels(){

	//Set Levels


	if (Game.GetPlayerIDsOnTeam( DOTATeam_t.DOTA_TEAM_GOODGUYS ).length > 0){
		$("#teamLevel2").text = Players.GetLevel(Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_GOODGUYS)[0]);
		
		var currentXP = Entities.GetCurrentXP(Players.GetPlayerHeroEntityIndex(Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_GOODGUYS)[0]));
		var neededXP =	Entities.GetNeededXPToLevel(Players.GetPlayerHeroEntityIndex(Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_GOODGUYS)[0]));
		
		//	$.Msg( neededXP - (neededXP - currentXP ) );
		
		currentXP -= perTeam1LvlFactor; 
		neededXP -= perTeam1LvlFactor; 
		
		perTeam1 = (currentXP * 100) / neededXP;
	}

	if (Game.GetPlayerIDsOnTeam( DOTATeam_t.DOTA_TEAM_BADGUYS ).length > 0){
		$("#teamLevel3").text = Players.GetLevel(Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_BADGUYS)[0]);
		
		var currentXP = Entities.GetCurrentXP(Players.GetPlayerHeroEntityIndex(Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_BADGUYS)[0]));
		var neededXP =	Entities.GetNeededXPToLevel(Players.GetPlayerHeroEntityIndex(Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_BADGUYS)[0]));
		
		currentXP -= perTeam2LvlFactor; 
		neededXP -= perTeam2LvlFactor; 
		
		perTeam2 = (currentXP * 100) / neededXP;
	}
  
	//Set XP Bars
	
	
	var left1 = $("#xpbar1Left");
	  left1.SetHasClass("TimeBlue", true);
	  left1.SetHasClass("TimeRed", false);

	  left1.style.transition = "width 0.1s linear 0.0s;"
	  left1.style.width = perTeam1 * 1 + "%";
	  
	  	var left2 = $("#xpbar2Left");
	  left2.SetHasClass("TimeBlue", false);
	  left2.SetHasClass("TimeRed", true);

	  left2.style.transition = "width 0.1s linear 0.0s;"
	  left2.style.width = perTeam2 * 1 + "%";
  
  
  
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
		$("#heroPanel").style["horizontal-align"] = "left;";
		$("#TimersPanel").style["horizontal-align"] = "right;";
		$("#MiniMapBorders").style["horizontal-align"] = "right;";
		$("#mapEventInfo").style["horizontal-align"] = "right;";


	}
	else {		
		$("#heroPanel").style["horizontal-align"] = "right;";
		$("#TimersPanel").style["horizontal-align"] = "left;";
		$("#MiniMapBorders").style["horizontal-align"] = "left;";
		$("#mapEventInfo").style["horizontal-align"] = "left;";

	}
	
	$.Schedule(1/10, checkFlipped);
}


function executeAbility(abilitySlotNumber) {
	Abilities.ExecuteAbility( Entities.GetAbility( Players.GetPlayerHeroEntityIndex( 0 ), abilitySlotNumber-1 ), Players.GetPlayerHeroEntityIndex( 0 ), false );
	
}

  var yourTeam = 0;
  var enemyTeam = 0;
	
function leveluptextteam2(){
	$("#levelupTextTeam2").visible = false;
}
function leveluptextteam3(){
	$("#levelupTextTeam3").visible = false;
}

function OnPlayerLevelUp( data ) {
	
	if (Game.GetPlayerIDsOnTeam(2).length > 0){

		if (data.playerID == Game.GetPlayerIDsOnTeam(2)[0] +1){

			var currentXP = Entities.GetCurrentXP(Players.GetPlayerHeroEntityIndex(Game.GetPlayerIDsOnTeam(2)[0]));
			var neededXP =	Entities.GetNeededXPToLevel(Players.GetPlayerHeroEntityIndex(Game.GetPlayerIDsOnTeam(2)[0]));
			
			perTeam1LvlFactor = ( neededXP - (neededXP - currentXP ) );
			
			$("#levelupTextTeam2").visible = true;
			
			$.Schedule( 4, leveluptextteam2 );

		}
	}
	if (Game.GetPlayerIDsOnTeam(3).length > 0){

		if (data.playerID == Game.GetPlayerIDsOnTeam(3)[0] +1){
			
			var currentXP1 = Entities.GetCurrentXP(Players.GetPlayerHeroEntityIndex(Game.GetPlayerIDsOnTeam(3)[0]));
			var neededXP1 =	Entities.GetNeededXPToLevel(Players.GetPlayerHeroEntityIndex(Game.GetPlayerIDsOnTeam(3)[0]));
			
			perTeam2LvlFactor = ( neededXP1 - (neededXP1 - currentXP1 ) );
			
			$("#levelupTextTeam3").visible = true;
			
			$.Schedule( 4, leveluptextteam3 );
			
			
		}
	}

}

function heroPanel(){


	var selectedEnt = Players.GetLocalPlayerPortraitUnit();

	  
	if(selectedEnt){
	  var healPer = Entities.GetHealthPercent( selectedEnt );

	  var currentHealth = Entities.GetHealth(selectedEnt );
	  var maxHealth = Entities.GetMaxHealth( selectedEnt );
		
	  var left2 = $("#healthbarLeft");


	  left2.style.transition = "width 0.1s linear 0.0s;"
	  left2.style.width = healPer + "%";

	  $("#healthbarText").text = currentHealth + " / " + maxHealth;
	  
	  // Mana
	  
	  if (Entities.GetMana(selectedEnt) > 0 ){
		  var maxMana = Entities.GetMaxMana( selectedEnt );
		  var currentMana = Entities.GetMana( selectedEnt );
		  
		  var manaPer = (currentMana * 100) / maxMana;
		  
		  var left1 = $("#manabarLeft");

		  left1.style.transition = "width 0.1s linear 0.0s;"
		  left1.style.width = manaPer + "%";
		  
		  $("#manabarText").text = currentMana + " / " + maxMana;
	  
	  }
	  
	  else {
		  $("#manabarText").text = "No Mana"
	  }
	  
	}
	  
	$.Schedule(1/10, heroPanel);
}

function heroCamera(){
	
var selectedEnt = Players.GetLocalPlayerPortraitUnit();
var unit = Entities.GetUnitName ( selectedEnt );

var sceneContainer = $("#heroCam");

$("#HeroPortrait").heroname = unit;

$.Schedule(1/10, heroCamera);

}

function showDynamicEventInfo(msg){
  $("#mapEventInfo").style["background-image"] = 'url("file://{images}/custom_game/maps/' + Game.GetMapInfo().map_display_name + '/eventMap.png")';
  $("#mapEventInfo").visible = true;
 
  
}
	
function hideDynamicEventInfo(){
  $("#mapEventInfo").visible = false;
}
	
(function(){

  yourTeam = Players.GetTeam(Players.GetLocalPlayer());

  if (yourTeam == 2){
	enemyTeam = 3;
  }
	
  else {
	enemyTeam = 2;
  }
  
  //Levelup text xp bar
  leveluptextteam2();
  leveluptextteam3();
  
  
  //Setup char camera 
  heroCamera();
  
  // capture bar
  TimeBar();

  heroDeathTimebar();
  
  heroPanel();
  
  //topBar
  showGameTime();
  teamLevels();
  
  //showCustomCursor()
  
  checkFlipped()
  
  GameEvents.Subscribe("showCapturepoint", showCapturepoint);
  GameEvents.Subscribe("hideCapturepoint", hideCapturepoint); 

  CustomNetTables.SubscribeNetTableListener( "merc_capturepoints", capturePointsChanged );
  CustomNetTables.SubscribeNetTableListener( "watch_capturepoints", capturePointsChanged );

  GameEvents.Subscribe("showDynamicEventInfo", showDynamicEventInfo);
  GameEvents.Subscribe("hideDynamicEventInfo", hideDynamicEventInfo); 
  CustomNetTables.SubscribeNetTableListener( "dynamic_MapEvents", dynamicEventInfoChanged );
  
  GameEvents.Subscribe( "dota_player_gained_level_all", OnPlayerLevelUp );
  
  GameEvents.Subscribe( "entity_killed", OnHeroDeath );
  GameEvents.Subscribe( "npc_spawned", OnHeroRespawn );

  
})(); 
