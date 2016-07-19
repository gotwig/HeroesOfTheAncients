"use strict";



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

var clickedHeroSwitch = true;


	
var selectedPlayerIDBlue = 100;
var selectedPlayerIDRed = 100;


function flipMinimap(){
	$.Msg( "Flipping Minimap" );
	var iPlayerid = Players.GetLocalPlayer();
	GameEvents.SendCustomGameEventToServer( "flipMinimap", { pID: iPlayerid })
}

function helpText(button, newText){
	$.DispatchEvent("DOTAShowTextTooltip", button, newText);
}

function helpHide(){
	$.DispatchEvent("DOTAHideTextTooltip");
}

function heroCamLock(){
	$.Msg( "Switching hero cam lock ON/OFF" );
	
	var iPlayerid = Players.GetLocalPlayer();
	var entityID = Players.GetLocalPlayerPortraitUnit();
	GameEvents.SendCustomGameEventToServer( "lockCameraToHero", { pID: iPlayerid, entID: entityID })
}


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

var teamDeathMax = [10]
var teamDeathOnce = [10]

function heroTeamDeathTimebar()
{
	  if (Game.GetAllPlayerIDs()){
	  
	  var playerIDs = Game.GetAllPlayerIDs()
	
	  for (var i = 0; i < playerIDs.length;i++){
		  if (Players.IsValidPlayerID( playerIDs[i] )){

			  var respawnSecs = Players.GetRespawnSeconds (playerIDs[i]);

			  if (respawnSecs < 0){
					$("#heroDeath" + (playerIDs[i])).visible = false;
					teamDeathOnce[playerIDs[i]] = false;
			  }
		  
			  if (respawnSecs > 0 && !teamDeathOnce[ playerIDs[i] ] ){
				  teamDeathMax[playerIDs[i]] = respawnSecs;
			  }
		  
			  if (respawnSecs > 0){
			  teamDeathOnce[playerIDs[i]] = true
				  				  
			  $("#heroDeath" + (playerIDs[i])).visible = true ;
			  var myStyle = $("#heroDeath" + (playerIDs[i]));
			  
			  myStyle.GetChild(1).heroname = Entities.GetUnitName(Players.GetPlayerHeroEntityIndex(playerIDs[i]))
			  myStyle.GetChild(2).text = respawnSecs;

			  //myStyle.SetHasClass("Team" +  Players.GetTeam( playerIDs[i] ) + "DeathBar", true);
			  
			  if (Players.GetTeam( playerIDs[i]) == DOTATeam_t.DOTA_TEAM_GOODGUYS) {
				 myStyle.style['margin-right'] = ( (830 / teamDeathMax[playerIDs[i]]) * respawnSecs ) + 560     + "px;";
			  }
			  
			  if (Players.GetTeam( playerIDs[i]) == DOTATeam_t.DOTA_TEAM_BADGUYS) {
				 myStyle.style['margin-left'] = ( (830 / teamDeathMax[playerIDs[i]]) * respawnSecs ) + 560     + "px;";
			  }
			  
			  //$("#heroDeath" + playerIDs[i]).style.margin = respawnSecs + "px";
			  }
			  }
		  

		  
	  }
	  }
	

	
  $.Schedule(1/1000, heroTeamDeathTimebar);
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

function heroTeamDeath(entity){
	
	var teamNumber = Entities.GetTeamNumber(entity)

	$("#heroDeath_" + teamNumber + "_" + 1).visible = true;
	
	$.Schedule(1, initTeamDeath);

}

function initDeath(){
	showDeathTimebar = true;	
}

function initTeamDeath(){
	showTeamDeathTimebar = true;
}

function OnHeroDeath(data){
	if (data.entindex_killed == Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ) ){
		$.Msg( "Your Hero Died" );
		
		initShowDeath = true;

		$.Schedule(1, initDeath);

		
	}
	
	//heroTeamDeath(data.entindex_killed);
	
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

function attributesChanged( table_name, key, data )
{
	if (key == Players.GetLocalPlayerPortraitUnit() ){
		
		$("#attributeStrText").text = Math.floor(data.str);
		$("#attributeIntText").text = Math.floor(data.int);
		$("#attributeAgiText").text = Math.floor(data.agi);
		
	}
}

function showGameTime(){
  minutes = Math.floor(Game.GetDOTATime( false, false)/60);
  seconds = Math.floor(Game.GetDOTATime( false, true) % 60); 
    
  if (seconds < -0){
	  seconds = seconds + 4;
  }
	
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

function refreshTeamXP(){
	

	for (var pID of Game.GetAllPlayerIDs()){
		if (Players.GetTeam( pID ) == DOTATeam_t.DOTA_TEAM_GOODGUYS ) {
			selectedPlayerIDBlue = pID
		}
		
		if (Players.GetTeam( pID ) == DOTATeam_t.DOTA_TEAM_BADGUYS ) {
			selectedPlayerIDRed = pID;
		}
	}	
	
	if (selectedPlayerIDBlue != 100){
		var currentXP = Entities.GetCurrentXP(Players.GetPlayerHeroEntityIndex(selectedPlayerIDBlue));
		var neededXP =	Entities.GetNeededXPToLevel(Players.GetPlayerHeroEntityIndex(selectedPlayerIDBlue));
			
		perTeam1LvlFactor = XP_PER_LEVEL_TABLE[Players.GetLevel( selectedPlayerIDBlue )];
		
		currentXP -= perTeam1LvlFactor; 
		neededXP -= perTeam1LvlFactor; 
		
		team_xpper2 = (currentXP * 100) / neededXP;
		 
		team_level2 = Players.GetLevel( selectedPlayerIDBlue );
		 
	}

	if (selectedPlayerIDRed != 100 ){

		var currentXP = Entities.GetCurrentXP(Players.GetPlayerHeroEntityIndex(selectedPlayerIDRed));
		var neededXP =	Entities.GetNeededXPToLevel(Players.GetPlayerHeroEntityIndex(selectedPlayerIDRed));
			
		perTeam2LvlFactor = XP_PER_LEVEL_TABLE[Players.GetLevel( selectedPlayerIDRed )];
		
		
		currentXP -= perTeam2LvlFactor; 
		neededXP -= perTeam2LvlFactor; 
		
		team_xpper3 = (currentXP * 100) / neededXP;
		 
		team_level3 = Players.GetLevel( selectedPlayerIDRed );
	}
	
	$.Schedule(0.5, refreshTeamXP);
}

	var perTeam1 = 0.1;
	var perTeam2 = 0.1;
	var perTeam1LvlFactor = 0.1;
	var perTeam2LvlFactor = 0.1;

	var team_level2 = 1;
	var team_level3 = 1;

	var team_xpper2 = 0;
	var team_xpper3 = 0;
	
	var XP_PER_LEVEL_TABLE = new Array ();
    XP_PER_LEVEL_TABLE[1] = 0
    XP_PER_LEVEL_TABLE[2] = 200
    XP_PER_LEVEL_TABLE[3] = 500
    XP_PER_LEVEL_TABLE[4] = 900
    XP_PER_LEVEL_TABLE[5] = 1400
    XP_PER_LEVEL_TABLE[6] = 2000
    XP_PER_LEVEL_TABLE[7] = 2600
    XP_PER_LEVEL_TABLE[8] = 3400
    XP_PER_LEVEL_TABLE[9] = 4400
    XP_PER_LEVEL_TABLE[10] = 5400
    XP_PER_LEVEL_TABLE[11] = 6000 
    XP_PER_LEVEL_TABLE[12] = 8200
    XP_PER_LEVEL_TABLE[13] = 9000
    XP_PER_LEVEL_TABLE[14] = 10400
    XP_PER_LEVEL_TABLE[15] = 11900
    XP_PER_LEVEL_TABLE[16] = 13500 
    XP_PER_LEVEL_TABLE[17] = 15200
    XP_PER_LEVEL_TABLE[18] = 17000 
    XP_PER_LEVEL_TABLE[19] = 18900 
    XP_PER_LEVEL_TABLE[20] = 20900 
    XP_PER_LEVEL_TABLE[21] = 23000 
    XP_PER_LEVEL_TABLE[22] = 25200
    XP_PER_LEVEL_TABLE[23] = 27500 
    XP_PER_LEVEL_TABLE[24] = 29900 
    XP_PER_LEVEL_TABLE[25] = 32400 
	
function teamLevel2(){

	if (Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_GOODGUYS).length > 0){

	  $("#teamLevel2").text = Players.GetLevel(Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_GOODGUYS)[0]);
		
	  perTeam1 = team_xpper2; 
	
	  var left1 = $("#xpbar1Left");
	  left1.SetHasClass("TimeBlue", true);
	  left1.SetHasClass("TimeRed", false);

	  left1.style.transition = "width 0.1s linear 0.0s;"
	  if (!isNaN(perTeam1)) {
		left1.style.width = perTeam1 + "%";
	  }
	}
  
  
	$.Schedule(1/10, teamLevel2);
}

function teamLevel3(){

	if (Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_BADGUYS).length > 0){
		
		$("#teamLevel3").text = Players.GetLevel(Game.GetPlayerIDsOnTeam(DOTATeam_t.DOTA_TEAM_BADGUYS)[0]);
		
		perTeam2 = team_xpper3; 
	  
	  var left2 = $("#xpbar2Left");
	  left2.SetHasClass("TimeBlue", false);
	  left2.SetHasClass("TimeRed", true);

	  left2.style.transition = "width 0.1s linear 0.0s;"

	  if (!isNaN(perTeam2)) {
		left2.style.width = perTeam2 + "%";
	  }
	}
  
	$.Schedule(1/10, teamLevel3);
}

function showCustomCursor(){
	
	if (Game.IsInAbilityLearnMode()){
		$("#cursorImage").visible = true;
	}
	
	else {
		$("#cursorImage").visible = false;
	}
	
	var xCor = GameUI.GetCursorPosition()[0];
	xCor += 25;
	
	var yCor = GameUI.GetCursorPosition()[1];
	yCor -= 5;
	
	$("#cursorImage").style["position"] = xCor + "px " + yCor + "px 0px;" 
			
	$.Schedule(1/1000, showCustomCursor);
}

function checkFlipped(){

	if (Game.IsHUDFlipped()){
		$("#heroPanel").style["horizontal-align"] = "left;";
		$("#MiniMapBorders").style["horizontal-align"] = "right;";
		$("#mapEventInfo").style["horizontal-align"] = "right;";


	}
	else {		
		$("#heroPanel").style["horizontal-align"] = "right;";
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

	if (data.team == DOTATeam_t.DOTA_TEAM_GOODGUYS){
		$("#levelupTextTeam2").visible = true;
		team_xpper2 = 0;
		$.Schedule( 4, leveluptextteam2 );
	}
	if (data.team == DOTATeam_t.DOTA_TEAM_BADGUYS ){
		$("#levelupTextTeam3").visible = true;
		team_xpper3 = 0;
		$.Schedule( 4, leveluptextteam3 );
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


var ability = Entities.GetAbilityByName( Players.GetLocalPlayerPortraitUnit(), "attribute_bonus");

var canUpgrade = Abilities.CanAbilityBeUpgraded( ability )

if (canUpgrade == 0 && Entities.GetAbilityPoints( Players.GetLocalPlayerPortraitUnit() ) > 0) {
		$("#levelupAttributesHint").visible = true;
}

else {
	$("#levelupAttributesHint").visible = false;
}

	if (Entities.IsHero( Players.GetLocalPlayerPortraitUnit() )){	
		var newUnit = CustomNetTables.GetTableValue( "hero_attributes", Players.GetLocalPlayerPortraitUnit() )
		
		if ( newUnit ){
			$("#attributeStrText").text = Math.floor(newUnit.str);
			$("#attributeIntText").text = Math.floor(newUnit.int);
			$("#attributeAgiText").text = Math.floor(newUnit.agi);
		}
		
	}
	
	if (!Entities.IsHero( Players.GetLocalPlayerPortraitUnit() )){

		$("#attributeStrText").text = "";
		$("#attributeIntText").text = "";
		$("#attributeAgiText").text = "";
	}


$.Schedule(1/10, heroCamera);

}

function showDynamicEventInfo(msg){
  $("#mapEventInfo").style["background-image"] = 'url("file://{images}/custom_game/maps/' + Game.GetMapInfo().map_display_name + '/eventMap.png")';
  $("#mapEventInfo").visible = true;
}
	
function hideDynamicEventInfo(){
  $("#mapEventInfo").visible = false;
}
	
	function updateHeroStats(){
	if (Entities.IsControllableByPlayer( Players.GetLocalPlayerPortraitUnit(), Players.GetLocalPlayer() )){
		Abilities.AttemptToUpgrade(Entities.GetAbilityByName( Players.GetLocalPlayerPortraitUnit(), "attribute_bonus"))
	}
	
}

	
(function(){

  yourTeam = Players.GetTeam(Players.GetLocalPlayer());

  if (yourTeam == DOTATeam_t.DOTA_TEAM_GOODGUYS ){
	enemyTeam = DOTATeam_t.DOTA_TEAM_BADGUYS ;
  }
	
  else {
	enemyTeam = DOTATeam_t.DOTA_TEAM_GOODGUYS;
  }
  
  //Levelup text xp bar
  leveluptextteam2();
  leveluptextteam3();
  
  
  //Setup char camera 
  heroCamera();
  
  // capture bar
  TimeBar();

  heroDeathTimebar();
  
  heroTeamDeathTimebar();
  
  heroPanel();
  
  //topBar
  showGameTime();
  teamLevel2();
  teamLevel3();

  showCustomCursor()
  
  checkFlipped();
  refreshTeamXP();
  
  GameEvents.Subscribe("showCapturepoint", showCapturepoint);
  GameEvents.Subscribe("hideCapturepoint", hideCapturepoint); 

  CustomNetTables.SubscribeNetTableListener( "merc_capturepoints", capturePointsChanged );
  CustomNetTables.SubscribeNetTableListener( "watch_capturepoints", capturePointsChanged );
  CustomNetTables.SubscribeNetTableListener( "hero_attributes", attributesChanged );

  
  
  GameEvents.Subscribe("showDynamicEventInfo", showDynamicEventInfo);
  GameEvents.Subscribe("hideDynamicEventInfo", hideDynamicEventInfo); 
  CustomNetTables.SubscribeNetTableListener( "dynamic_MapEvents", dynamicEventInfoChanged );
    
  GameEvents.Subscribe( "dota_player_gained_level_all", OnPlayerLevelUp );
  
  GameEvents.Subscribe( "entity_killed", OnHeroDeath );
  GameEvents.Subscribe( "npc_spawned", OnHeroRespawn );

})(); 
