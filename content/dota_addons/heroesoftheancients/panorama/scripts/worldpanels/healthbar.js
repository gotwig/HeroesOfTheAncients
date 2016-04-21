$.Msg("healthbar");

var teamColors = GameUI.CustomUIConfig().team_colors;

if (!teamColors) {
  GameUI.CustomUIConfig().team_colors = {}
  GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_GOODGUYS] = "#3dd296;";
  GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_BADGUYS ] = "#F3C909;";
  GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_1] = "#c54da8;";
  GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_2] = "#FF6C00;";
  GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_3] = "#3455FF;";
  GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_4] = "#65d413;";
  GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_5] = "#815336;";
  GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_6] = "#1bc0d8;";
  GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_7] = "#c7e40d;";
  GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_8] = "#8c2af4;";

  teamColors = GameUI.CustomUIConfig().team_colors;
}

teamColors[DOTATeam_t.DOTA_TEAM_NEUTRALS] = teamColors[DOTATeam_t.DOTA_TEAM_NEUTRALS] || "#aaaaaa;";
teamColors[DOTATeam_t.DOTA_TEAM_NOTEAM]   = teamColors[DOTATeam_t.DOTA_TEAM_NOTEAM]   || "#aaaaaa;";

function HealthCheck()
{
  var wp = $.GetContextPanel().WorldPanel
  var offScreen = $.GetContextPanel().OffScreen;
  if (!offScreen && wp){
    var ent = wp.entity;
    if (ent){
      if (!Entities.IsAlive(ent)){
        $.GetContextPanel().style.opacity = "0";
        $.Schedule(1/30, HealthCheck);
        return;
      }

      //var pTeam = Players.GetTeam(Game.GetLocalPlayerID());
      var team = Entities.GetTeamNumber(ent);

      // Color by friendly/enemy
      /*if (team == pTeam)
        $.GetContextPanel().SetHasClass("Friendly", true);
      else
        $.GetContextPanel().SetHasClass("Friendly", false);*/

      $.GetContextPanel().style.opacity = "1";

	   var mp = Entities.GetMana(ent);
       var mpMax = Entities.GetMaxMana(ent);
       var mpPer = (mp * 100 / mpMax).toFixed(0);
	  
	  
		  for (var i=0; i <= Game.GetAllPlayerIDs().length; i++){
			  if( Players.IsValidPlayerID( i ) ){
				if (Players.GetPlayerHeroEntityIndex( i ) == ent ){
					$("#playerHeroName").text = Players.GetPlayerName( i );

				}
			  }
		  }
		
        var pan = $("#hp");

        pan.style.width = Entities.GetHealthPercent(ent) + "%;";
		
		pan.style.backgroundColor = "#61C2D3;";

		var yourTeamNumber = Entities.GetTeamNumber( Players.GetLocalPlayerPortraitUnit() );
		
		if (  Entities.IsControllableByPlayer( ent, Players.GetLocalPlayer() ) ){
			pan.style.backgroundColor = "#f4e91e;";
		}
		
		if ( yourTeamNumber  != Entities.GetTeamNumber(ent) ){
			pan.style.backgroundColor = "#d12746;";
		}
	  
	   if (mpMax > 0){
			$("#mp").style.width = mpPer + "%;";
	   }
	   else {
		   $("#manabar").visible = false;
	   }

	  
    }
  }

  $.Schedule(1/30, HealthCheck);
}

(function()
{ 
  HealthCheck();

})();