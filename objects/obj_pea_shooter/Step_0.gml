enum peashooter_state {
	idle,
	burrowed,
	agro,
	attacking,
	death,
}

switch(state){
	#region idle case
	case peashooter_state.idle:
	agro = false
		sprite_index = spr_pea_shooter_burrowed
		alarm[3] = 120
			_speed = ENEMY_DEFAULT_SPEED
			if idle_movement = 0
			{
				x += _speed * irandom_range(-3, 3)
				y += _speed * irandom_range(-3, 3)
				idle_movement = 1
				alarm[1] = 60
			}
			if (collision_circle(x, y, agro_radius, obj_player, false, true)) {state = peashooter_state.agro} 
		break
		#endregion
	#region agro case
	case peashooter_state.agro:
		_speed = ENEMY_DEFAULT_SPEED
		agro = true
		sprite_index = spr_pea_shooter_angry_burrowed
		if (obj_player.x < x) {image_xscale = -1} else {image_xscale = 1} 
		if (agro == true) { check_for_player_ranged() }
		if (collision_circle(x, y, attack_radius, obj_player, false, false)) {state = peashooter_state.attacking}
		if (collision_circle(x, y, vision_radius, obj_player, false, false)
			&& (!collision_circle(x, y, agro_radius, obj_player, false, false)) && (agro == false)) {state = peashooter_state.idle}
		break
		#endregion
		#region attacking case
	case peashooter_state.attacking:
		_speed = 0
		sprite_index = spr_pea_shooter
		if (shoot_cooldown == false) {
		if (obj_player.x < x) {image_xscale = -1} else {image_xscale = 1} 
		var _direction = point_direction(x, y, obj_player.x, obj_player.y)
		instance_create_layer( x, y, "other", obj_pea_bullets, 
			{ speed: 10, direction: _direction, image_angle: _direction })
		shoot_cooldown = true
		alarm[0] = 60
		}
		if !(collision_circle(x, y, attack_radius, obj_player, false, false)) {state = peashooter_state.agro}
		break
		#endregion
}