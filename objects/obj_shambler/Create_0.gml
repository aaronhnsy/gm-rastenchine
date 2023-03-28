event_inherited()
vision_radius = 500
attack_radius = 100
chase_radius = 300
//unique vars
explode_timer = 0

sprite_idle =  spr_shambler
sprite_wandering =  spr_shambler
sprite_wandering_cooldown = spr_shambler_cooldown
sprite_chasing = spr_shambler_agro
sprite_lost = spr_shambler_cooldown
sprite_charging = spr_shambler_charging
sprite_attacking = spr_shambler_explode
sprite_attacking_cooldown = spr_shambler_cooldown
sprite_death = spr_shambler_death

within_attack_radius = false
within_chase_radius = false
within_vision_radius = false

wander_x = 0
wander_y = 0

path_cooldown = 10

state = new SnowState("idle")
//sleeping during night hours wandering through day hours 
state.add(
	"sleeping", {
		enter: function() {
			sprite_index = sprite_sleeping
		},
		step: function() {
			//will also need cheese item + must be crouching?
			if (collision_circle(x, y, 50, obj_player, false, false)) && keyboard_check_pressed(ord("E")){
				instance_create_layer(x,y,"other",obj_tamed_shambler)
				instance_destroy()
			}
			if (within_chase_radius) { return state.change("chasing") }
			if (within_vision_radius) { return state.change("wandering") }	
		}
	}
) 
state.add(
	"idle", {
		enter: function() { 
			sprite_index = sprite_idle 
		},
		step: function() {
			if (within_chase_radius) { return state.change("chasing") }
			if (within_vision_radius) { return state.change("wandering") }	
		}
	}
) 

state.add(
	"wandering", {
		enter: function() { 
			sprite_index = sprite_wandering 
			if (created_by_spawner) {
				wander_x = irandom_range(spawner_bbox_left - 100, spawner_bbox_right + 100)
				wander_y = irandom_range(spawner_bbox_top - 100, spawner_bbox_bottom + 100)
			}
			else {
				wander_x = irandom_range(bbox_left - 200, bbox_right + 200)
				wander_y = irandom_range(bbox_top - 200, bbox_bottom + 200)
			}
			var path_found = mp_grid_path(global.mp_grid, path, x, y, wander_x, wander_y, irandom_range(0, 1))
			if (path_found) { path_start(path, 2, path_action_stop, false) }
		},
		step: function() {
			if (within_chase_radius) { return state.change("chasing") }
			if (path_position == 1) { state.change("wandering_cooldown") }
		}
	}
)
state.add(
	"wandering_cooldown", {
		enter: function() { 
			sprite_index = sprite_wandering_cooldown
			alarm[0] = 120
		},
		step: function() {
			if (within_chase_radius) { return state.change("chasing") }
		}
	}
)

state.add(
	"chasing", {
		enter: function() { 
			sprite_index = sprite_chasing 
		},
		step: function() {
			if (obj_player.x < x) {image_xscale = -1} else {image_xscale = 1}
			if (within_attack_radius) { return state.change("charging") }
			if (!within_chase_radius) { return state.change("lost") }
			path_cooldown -= 1
			if (path_cooldown <= 0) {
				path_cooldown = 20
				var path_found = mp_grid_path(global.mp_grid, path, x, y, obj_player.x, obj_player.y, true)
				if (path_found) { path_start(path, _speed, path_action_stop, false) }
			}
		}
	}
)
state.add(
	"lost", {
		enter: function() { 
			sprite_index = sprite_lost 
			alarm[0] = 120
		},
		step: function() {
			if (within_chase_radius) { return state.change("chasing") }
		}
	}
)
state.add(
	"charging", {
		enter: function() {
			if (obj_player.x < x) {image_xscale = -1} else {image_xscale = 1}
			sprite_index = sprite_charging 
			path_end()
		},
		step: function() {
			explode_timer += 0.1
			//if sprite_index == sprite_charging{_speed = 0}
			if !(collision_circle(x, y, attack_radius, obj_player, false, false)){
				//_speed = ENEMY_DEFAULT_SPEED 
				explode_timer -= 0.2
				if explode_timer <= 0 { 
					explode_timer = 0
					state.change("chasing")
				}
			}
			if explode_timer >= 8 {state.change("attacking")}
		}
	}
)
state.add(
	"attacking", {
		enter: function() {
			if (obj_player.x < x) {image_xscale = -1} else {image_xscale = 1}
			sprite_index = sprite_attacking
			path_end()
		},
		step: function() {
			if (image_index	>= image_number - 1) {
				instance_destroy()
			}
		}
	}
)