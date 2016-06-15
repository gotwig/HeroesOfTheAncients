var allHeroes = {};
var heroButtons = {};
var playerColors = {};
var selectedHeroes = {};
var previewSchedule = 0;
var hidingCurrentPreview = null;
var playerConnectionStates = {};
var heroPreviews = {};

var currentHeroSound = 0;

var myGlobalHeroes = {};

var mySelectedHero = "";

var abilitiesToShow = {};

var charLocked = false;

function CreateDifficultyLock() {
    var lockedHeroes = $("#HardHeroes");
    var background = $("#HeroSelectionBackground");
    var relation = 1080 / background.actuallayoutheight;

    var lock = $.CreatePanel("Panel", $("#HeroSelectionBackground"), "DifficultyLock");
    var startY = (lockedHeroes.GetPositionWithinWindow().y - 3) * relation;

    var widestRow = _(lockedHeroes.Children()).max(function(row) { return row.actuallayoutwidth });

    var startX = (widestRow.GetPositionWithinWindow().x - 3) * relation;

    if (startX == Infinity || startY == Infinity) {
        $.Schedule(0.01, CreateDifficultyLock);
        lock.DeleteAsync(0);
        return;
    }

    lock.style.x = startX + "px";
    lock.style.y = startY + "px";
    lock.style.height = ((lockedHeroes.actuallayoutheight + 6) * relation) + "px";
    lock.style.width = ((widestRow.actuallayoutwidth + 6) * relation) + "px";

    var image = $.CreatePanel("Panel", lock, "");
    var text = $.CreatePanel("Label", lock, "");
    
    text.text = $.Localize("LockedHeroes");
}

function PreloadHeroPreviews(heroes) {
    var previewStyle = "width: 100%; height: 100%; margin-top: -100px; opacity-mask: url(\"s2r://panorama/images/masks/softedge_box_png.vtex\");";
    for (var hero of heroes) {
        var preview = $.CreatePanel("Panel", $("#LeftSideHeroes"), "");
        preview.AddClass("HeroPreview");
        $("#LeftSideHeroes").MoveChildAfter(preview, $("#HeroAbilities"));

        preview.style.visibility = "collapse";
        preview.SetHasClass("NotAvailableHero", allHeroes[hero].disabled);
        preview.LoadLayoutFromStringAsync("<root><Panel><DOTAScenePanel style='" + previewStyle + "' unit='" + hero + "'/></Panel></root>", false, false);

        heroPreviews[hero] = preview;
    }
}

function LoadHeroPreview(heroname) {
    var previewStyle = "width: 100%; height: 100%; margin-top: -100px; opacity-mask: url(\"s2r://panorama/images/masks/softedge_box_png.vtex\");";
    for (var hero of myGlobalHeroes) {
		if (hero == heroname){
			var preview = $.CreatePanel("Panel", $("#LeftSideHeroes"), "");
			preview.AddClass("HeroPreview");
			$("#LeftSideHeroes").MoveChildAfter(preview, $("#HeroAbilities"));

			preview.style.visibility = "collapse";
			preview.SetHasClass("NotAvailableHero", allHeroes[hero].disabled);
			preview.LoadLayoutFromStringAsync("<root><Panel><DOTAScenePanel style='" + previewStyle + "' unit='" + hero + "'/></Panel></root>", false, false);

			heroPreviews[hero] = preview;
		}
    }
}
$.DispatchEvent("UIShowCustomLayoutTooltip", $.GetContextPanel(), "ItemTooltip", "file://{resources}/layout/custom_game/item_tooltip/poe.xml"); 
function SetAbilityButtonTooltipEvents(button, name) {
    button.SetPanelEvent("onmouseover", function() {
		$.DispatchEvent( "DOTAShowAbilityTooltip", button, name);
    });

    button.SetPanelEvent("onmouseout", function() {
        $.DispatchEvent("DOTAHideAbilityTooltip");
    });
}

function ShowHeroAbilities(heroName) {
    var hero = allHeroes[heroName];
	
	$.Msg(abilitiesToShow);
    // {"1":"dragon_knight_breathe_fire","2":"dragon_knight_dragon_tail","3":"dragon_knight_dragon_blood","4":"dragon_knight_elder_dragon_form"}	

		$("#HeroAbilities").RemoveAndDeleteChildren();
		
		for (var i = 1; i <= Object.keys(abilitiesToShow).length; i++) {
			var ability = abilitiesToShow[i];
			
			if (ability != "attribute_bonus" && ability.indexOf("hidden") <= -1 && ability.indexOf("empty") <= -1){
			
				var abilityPanel = $.CreatePanel( "Panel", $("#HeroAbilities"), "" );
				
				abilityPanel.LoadLayoutFromStringAsync('<root> <Panel class="AbilityRow"><Button><DOTAAbilityImage abilityname="'
				+ ability  + '"/></Button></Panel> </root>', false, false);
				
				SetAbilityButtonTooltipEvents( abilityPanel, ability)
				}
		}

}



function HideHeroDetails(heroName) {
    var selected = selectedHeroes[Game.GetLocalPlayerID()];

    if (!selected || selected == "null") {
        heroPreviews[heroName].RemoveClass("HeroPreviewIn");
        hiddingCurrentPreview = heroName;

        previewSchedule = $.Schedule(0.1, function() {
            $("#HeroAbilities").visible = false;
            $("#HeroName").text = "";

            heroPreviews[heroName].style.visibility = "collapse";
            previewSchedule = 0;
        });
    } else {
        ShowHeroDetails(selected);
    }
}

function ShowHeroDetails(heroName) {
		
	LoadHeroPreview(heroName);
    var selected = selectedHeroes[Game.GetLocalPlayerID()];

    if (selected && selected != "null" && selected != heroName) {
        return;
    }

    var abilityPanel = $("#HeroAbilities");
    var heroData = allHeroes[heroName];
    var notAvailable = allHeroes[heroName].disabled;

	
	if (mySelectedHero){
		HideHeroDetails(mySelectedHero);
	}
	
	mySelectedHero = heroName;
	
    ShowHeroAbilities(heroName);
    $("#HeroAbilities").visible = true;
    $("#HeroName").text = $.Localize(heroData.name);

    $("#HeroAbilities").SetHasClass("NotAvailableHero", notAvailable);
    $("#HeroName").SetHasClass("NotAvailableHero", notAvailable);

    heroPreviews[heroName].style.visibility = "visible";
    heroPreviews[heroName].AddClass("HeroPreviewIn");

    if (previewSchedule != 0) {
        $.CancelScheduled(previewSchedule);
        heroPreviews[hiddingCurrentPreview].style.visibility = "collapse";
        previewSchedule = 0;
    }
	
}

function confirmSelection(){
	GameEvents.SendCustomGameEventToServer("selection_hero_confirm", {});
	charLocked = true;
	$("#ConfirmText").text = "LOCKED | Game starts Soon...";
	$("#ConfirmSelection").RemoveClass("ConfirmSelectionButton");
} 
 

function PickRandomHero(){
	    GameEvents.SendCustomGameEventToServer("selection_random", {});
        Game.EmitSound("UI.SelectHeroLocal");
    if (selectedHeroes[Game.GetLocalPlayerID()] == "null") {
        GameEvents.SendCustomGameEventToServer("selection_random", {});
        Game.EmitSound("UI.SelectHeroLocal");
    }
}

function AddButtonEvents(button, name) {
    button.SetPanelEvent("onactivate", function() {
        var heroSelected = _.contains(_.values(selectedHeroes), name);

        if (!heroSelected) {
            Game.EmitSound("UI.SelectHeroLocal");
			$.Msg(mySelectedHero)
			//HideHeroDetails(mySelectedHero);
			
			abilitiesToShow =  CustomNetTables.GetTableValue( "hero_Abilities", name );
			
			if (!charLocked){
				$("#ConfirmSelection").style.opacity = 1;
				ShowHeroDetails(name);
				GameEvents.SendCustomGameEventToServer("selection_hero_click", { "hero": name });
				
			}
        }
    });

    button.SetPanelEvent("onmouseover", function() {
		
    });

    button.SetPanelEvent("onmouseout", function(){
    });
}

function AddDisabledButtonEvents(button, name) {
    button.SetPanelEvent("onmouseover", function() {
        $.DispatchEvent("DOTAShowTextTooltip", button, $.Localize("Available_on_" + name))

        //ShowHeroDetails(name);
    });

    button.SetPanelEvent("onmouseout", function(){
        $.DispatchEvent("DOTAHideTextTooltip");

        //HideHeroDetails(name);
    });
}

function CreateHeroList(heroList, heroes, rows, randomButtonRow, position){
    DeleteChildrenWithClass(heroList, "HeroButtonContainer");

    heroes = _(heroes).sortBy(function(hero) { return allHeroes[hero].disabled });

    var heroesInRow = rows[0];
    var randomAdded = false;

    for (var i = 0, currentRow = 0; i < heroes.length; currentRow++, i += heroesInRow, heroesInRow = rows[currentRow]) {
        var row = $.CreatePanel("Panel", heroList, "");
        row.AddClass("HeroButtonRow");
		
		if (position == "left"){
			row.AddClass("HeroButtonRowLeft");
			var container = $.CreatePanel("Panel", row, "");
			container.AddClass("HeroButtonContainerChar");
			var button = $.CreatePanel("Label", container, "");
			button.AddClass("OrderChar")
			button.text = heroes[i].charAt(14).toUpperCase();
		}
		
		if (position == "right"){
			row.AddClass("HeroButtonRowRight");
			randomAdded = true;
		}
		
        for (var j = i; j < heroes.length && j < i + heroesInRow; j++) {
            var notAvailable = allHeroes[heroes[j]].disabled;

            var container = $.CreatePanel("Panel", row, "");
            container.AddClass("HeroButtonContainer");

            if (currentRow == randomButtonRow - 1 && (j - i) == Math.floor(heroesInRow / 2) && !randomAdded) {
                j--;
                randomAdded = true;

                var button = $.CreatePanel("Panel", container, "");
                button.AddClass("RandomButton");

                container.SetPanelEvent("onactivate", PickRandomHero);
            } else {
                var button = $.CreatePanel("DOTAHeroImage", container, "");
                button.AddClass("HeroButton");
                button.SetHasClass("NotAvailableHeroButton", notAvailable);
                button.SetScaling("stretch-to-fit-x-preserve-aspect");
                button.heroname = heroes[j];
                button.heroimagestyle = "portrait";

                if (notAvailable) {
                    AddDisabledButtonEvents(container, heroes[j])
                } else {
                    AddButtonEvents(container, heroes[j]);
                }

                heroButtons[heroes[j]] = container;
            }
        }
		
		if (position == "right"){
			row.AddClass("HeroButtonRowLeft");
			var container = $.CreatePanel("Panel", row, "");
			container.AddClass("HeroButtonContainerChar");
			var button = $.CreatePanel("Label", container, "");
			button.AddClass("OrderChar")
			button.text = heroes[i].charAt(14).toUpperCase();
			
		}
		
    }
}

function OnTimerTick(args){
    if (args["time"] != -1) {
        $("#TimerText").text = args["time"].toString() + " seconds left";
    } else {
        $("#TimerText").text = "Have Fun!";
    }
}

function GameStateChanged(data){
    var bg = $("#HeroSelectionBackground");

	if(data){
			if (data.state == 2){
			bg.style.visibility = "visible";
			SwitchClass(bg, "AnimationBackgroundInvisible", "AnimationBackgroundVisible")
			//Game.EmitSound("UI.SelectionStart")

			$("#HeroAbilities").visible = false;
			$("#HeroName").text = "";

			for (var key in heroButtons) {
				heroButtons[key].style.boxShadow = null;
				heroButtons[key].RemoveClass("HeroButtonSaturated");
			}

			selectedHeroes = {};

			for (var preview in heroPreviews) {
				heroPreviews[preview].style.visibility = "collapse";
			}
		} else {
			SwitchClass(bg, "AnimationBackgroundVisible", "AnimationBackgroundInvisible")
			$.GetContextPanel().DeleteAsync(0);
			
		}
	}

}

function FilterDifficulty(heroes, data, difficulty) {
    return _.filter(heroes, function(hero) {
        return data[hero].difficulty == difficulty;
    });
}


function keys(obj)
{
    var keys = [];

    for(var key in obj)
    {
        if(obj.hasOwnProperty(key))
        {
            keys.push(key);
        }
    }

    return keys;
}

function HeroesUpdated(data){
	if (!data) {
        return;
    }

    allHeroes = data;

    var heroes = Object.keys(data);
	
	heroes = heroes.sort(function(a, b){
		if(a < b) return -1;
		if(a > b) return 1;
		return 0;
	})
	
	myGlobalHeroes = heroes;
	
    //PreloadHeroPreviews(heroes);
		
    var leftSide = heroes.slice(1, 55)
    var rightSide =  heroes.slice(55, 116)

    CreateHeroList($("#LeftHeroes"), leftSide, [ 5, 6, 6, 5, 5, 5, 5, 5, 5, 4, 3, 2 ] , 1, "left");
	CreateHeroList($("#RightHeroes"), rightSide, [ 6, 6, 6, 5, 5, 5, 5, 5, 5, 4, 3, 1 ] , 1, "right");
}

function PlayersUpdated(data){
    var playersPanel = $("#PlayersContent");
    DeleteChildrenWithClass(playersPanel, "TeamPanel");

    CreateScoreboardFromData(data, function(color, score, team) {
        var panel = $.CreatePanel("Panel", playersPanel, "");
        panel.AddClass("TeamPanel");

        var players = $.CreatePanel("Panel", panel, "");
        players.AddClass("TeamPanelPlayers");
        players.style.color = color;

        for (var player of team) {
			
			
            var playerPanel = $.CreatePanel("Panel", players, "");
            playerPanel.AddClass("TeamPlayer");

			var scorePanel = $.CreatePanel("Label", playerPanel, "");
			scorePanel.AddClass("TeamScore");
			
			
			if (Players.GetTeam( player.id ) == 2 ){
				scorePanel.text = "BLUE";
			}
		
			if (Players.GetTeam( player.id ) == 3 ){
				scorePanel.text = "RED";
			}
			
				if (Players.GetTeam(Players.GetLocalPlayer()) == Players.GetTeam( player.id )  ){
					var playerHero = $.CreatePanel("DOTAHeroMovie", playerPanel, "SelectionImage" + player.id);
					playerHero.AddClass("SelectionImage");
					
					if (player.selectionLocked == 1){
						playerHero.AddClass("AnimationSelectedHero");
					}
					
					else {
						playerHero.AddClass("AnimationImageHover");
					}
					
					playerHero.heroimagestyle = "landscape";
					playerHero.heroname = player.hero;
				
				}
				
				else {
					if (player.selectionLocked == 1){
						var playerHero = $.CreatePanel("DOTAHeroMovie", playerPanel, "SelectionImage" + player.id);
						playerHero.AddClass("SelectionImage");
						playerHero.AddClass("AnimationSelectedHero");
						playerHero.heroimagestyle = "landscape";
						playerHero.heroname = player.hero;
					}
				}
				


            var playerName = $.CreatePanel("Label", playerPanel, "");
            playerName.text = player.name;

            var connectionStatePanel = $.CreatePanel("Panel", playerName, "");
            connectionStatePanel.AddClass("ConnectionStatePanel");

            playerConnectionStates[player.id] = connectionStatePanel;

            playerColors[player.id] = color;
        }
    });
}

function HeroSelectionUpdated(data){
    selectedHeroes = data || {};

	$.Msg("hey there")
	
    for (var key in data){
        var hero = data[key];
        var selectionImage = $("#SelectionImage" + key);
        var id = parseInt(key);

        if (hero == "null"){
            selectionImage.RemoveClass("AnimationSelectedHero");
			selectionImage.AddClass("AnimationImageHover");

        } else {
            selectionImage.heroname = hero;
            selectionImage.AddClass("AnimationImageHover");

            heroButtons[hero].style.boxShadow = playerColors[id] + " -2px -2px 4px 4px";
            heroButtons[hero].AddClass("HeroButtonSaturated");
        }
    }
}

function CheckPause() {
    $.Schedule(0.3, CheckPause);
    $("#HeroSelectionBackground").SetHasClass("PauseBackground", Game.IsGamePaused());
    $("#PauseOverlay").style.visibility = Game.IsGamePaused() ? "visible" : "collapse";
}

function CheckConnectionState() {
    $.Schedule(0.1, CheckConnectionState);

    for (var id in playerConnectionStates) {
        var panel = playerConnectionStates[id];
        var state = Game.GetPlayerInfo(parseInt(id)).player_connection_state;

        panel.SetHasClass("ConnectionStateDisconnected", state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_DISCONNECTED);
        panel.SetHasClass("ConnectionStateAbandoned", state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_ABANDONED);
        panel.GetParent().SetHasClass("ConnectionStateAbandonedName", state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_ABANDONED);
    }
}

(function () {
    GameEvents.Subscribe("timer_tick", OnTimerTick);

    SubscribeToNetTableKey("main", "heroes", true, HeroesUpdated);
    SubscribeToNetTableKey("main", "players", true, PlayersUpdated);
    SubscribeToNetTableKey("main", "gameState", true, GameStateChanged);
    SubscribeToNetTableKey("main", "selectedHeroes", true, HeroSelectionUpdated);
	
    $("#HeroSelectionChat").BLoadLayout("file://{resources}/layout/custom_game/simple_chat.xml", false, false);
    $("#HeroSelectionChat").RegisterListener("HeroSelectionEnter");

    CheckConnectionState();
    CheckPause();
	
})();