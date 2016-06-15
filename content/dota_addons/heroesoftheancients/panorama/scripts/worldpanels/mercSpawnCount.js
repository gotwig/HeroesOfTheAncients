var seconds = -1;
var minutes = 0;


var otherSeconds = 0;

var myNumber = 0; 

function changeTime()
{
var wp = $.GetContextPanel().WorldPanel
var offScreen = $.GetContextPanel().OffScreen;

if (wp){
	
  myNumber = wp.name;
  
  minutes = Math.floor(seconds / 60);
  seconds = Math.floor(seconds % 60); 

  otherSeconds = seconds + 1;
  
  if (otherSeconds < 10) {
	otherSeconds = "0" + otherSeconds;
  }
  
  if (otherSeconds > 0){
	 $("#respawnText").text = "Camp Respawn in";
	 $("#countTime").text = "0" + minutes + ":" + otherSeconds;  
  }
  else {
	$("#respawnText").text = "Camp is fighting";
	$("#countTime").text = "";
  }
  
}
  $.Schedule(1/30, changeTime);
}

function capturePointsChanged( table_name, key, data )
{

	if (myNumber == key ){ 
		seconds = data.value;
	}
}

(function()
{ 
  changeTime();

  
  CustomNetTables.SubscribeNetTableListener( "merc_capturepoints", capturePointsChanged );

  
})();