function showCustomCursor(){
	$("#cursorImage").style["position"] = GameUI.GetCursorPosition()[0] + "px " + GameUI.GetCursorPosition()[1] + "px 0px;" 
	$.Schedule(1/1000, showCustomCursor);

}

(function(){

showCustomCursor();
})(); 