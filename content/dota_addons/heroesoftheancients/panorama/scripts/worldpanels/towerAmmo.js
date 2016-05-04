$.Msg("AMMO CHECK");

var ent = null;

function ammoCheck()
{
  var wp = $.GetContextPanel().WorldPanel
  var offScreen = $.GetContextPanel().OffScreen;
  if (!offScreen && wp){
    ent = wp.entity;
    if (ent){
      if (!Entities.IsAlive(ent)){
        $.GetContextPanel().style.opacity = "0";
        $.Schedule(1/30, HealthCheck);
        return;
      }

	if (wp.name > 20){
		$("#remainingAmmoTop2").visible = true;
	}
	  
	  
    }
  }

  $.Schedule(1/30, ammoCheck);
}

function ammoPointsChanged( table_name, key, data )
{
	if (ent == key){			
		
		if (data.value <= 20){
			$("#remainingAmmoLeft2").style.width = "0%";
			$("#remainingAmmoLeft").style.width = (data.value * 5) + "%";
		}
		
		if (data.value > 20){
			$("#remainingAmmoLeft").style.width = "100%";
			$("#remainingAmmoLeft2").style.width = ((data.value-20) * 5) + "%";
		}
		
		if (data.value > 0){
			$("#noAmmo").visible = false;
		}
		else {
			$("#noAmmo").visible = true;
		}
		
		
	}
}

(function()
{ 

  ammoCheck();

  CustomNetTables.SubscribeNetTableListener( "tower_ammoPoints", ammoPointsChanged );
  
})();