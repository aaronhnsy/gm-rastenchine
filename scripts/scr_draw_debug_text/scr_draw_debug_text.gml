function draw_debug_text() {

	draw_set_halign(fa_left)
	draw_set_valign(fa_bottom)
	
	var names = "Shadow Intensity: \nTime: \nMovement State: \nSpeed: "
	var values = string(global.ambientShadowIntensity) + "\n" + string(global.time) + "\n" + string(movement_state) + "\n" + string(_speed)
	
	var item = inventory.item
	if (is_instanceof(item, Weapon)) {
		names += "\nItem State: \nItem Damage: "
		values += "\n" + string(item.state) + "\n" + string(item.damage)
 	}
	if (is_instanceof(item, Crowbar)) {
		names += "\nCrowbar Charge: "
		values += "\n" + string(item.charge)
	}
	else if (is_instanceof(item, Gun) or is_instanceof(item, Railgun) or is_instanceof(item, Rifle) or is_instanceof(item, Shotgun)) {
		names += "\nGun Ammo: \nGun Clip: "
		values += "\n" + string(item.ammo) + "\n" + string(item.clip)
		
	}

	draw_text_color( 
		UI_X1 + UI_MARGIN, 
		UI_Y2 - UI_MARGIN, 
		names, 
		c_white, c_white, c_white, c_white,
		1
	)
	draw_text_color(
		UI_X1 + UI_MARGIN + string_width(names), 
		UI_Y2 - UI_MARGIN,
		values,
		c_white, c_white, c_white, c_white,
		1
	)
	
}
