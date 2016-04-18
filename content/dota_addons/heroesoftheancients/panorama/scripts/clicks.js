"use strict";


// Handle Right Button events
function OnRightButtonPressed()
{
	

	var iPlayerID = Players.GetLocalPlayer();
	var mainSelected = Players.GetLocalPlayerPortraitUnit(); 
	var mainSelectedName = Entities.GetUnitName( mainSelected )
	var cursor = GameUI.GetCursorPosition();
	var mouseEntities = GameUI.FindScreenEntities( cursor );
	mouseEntities = mouseEntities.filter( function(e) { return e.entityIndex != mainSelected; } )
	
	var pressedShift = GameUI.IsShiftDown();
	


	// Unit rightclick
	if (mouseEntities.length > 0)
	{	
		for ( var e of mouseEntities )
		{
			// Moonwell rightclick
			if (Entities.GetUnitName(e.entityIndex) == "nightelf_moon_well" )
			{
				$.Msg("Player "+iPlayerID+" Clicked on moon well to replenish")
				GameEvents.SendCustomGameEventToServer( "moonwell_order", { pID: iPlayerID, mainSelected: mainSelected, targetIndex: e.entityIndex })
				return false; //Keep the unit order
			}

		}
	}

	return false;
}

// Main mouse event callback
GameUI.SetMouseCallback( function( eventName, arg ) {
    var CONSUME_EVENT = true;
    var CONTINUE_PROCESSING_EVENT = false;
    var LEFT_CLICK = (arg === 0)
    var RIGHT_CLICK = (arg === 1)

    if ( GameUI.GetClickBehaviors() !== CLICK_BEHAVIORS.DOTA_CLICK_BEHAVIOR_NONE )
        return CONTINUE_PROCESSING_EVENT;

    var mainSelected = Players.GetLocalPlayerPortraitUnit()

    if ( eventName === "pressed" || eventName === "doublepressed")
    {
        // Clicks        

		if (RIGHT_CLICK) 
            return OnRightButtonPressed(); 
        
    }
    return CONTINUE_PROCESSING_EVENT;
} );