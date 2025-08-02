class_name IdleState
extends PlayerState


func enter_state() -> void:
	state_name = "Idle"


func exit_state() -> void:
	pass


func update_state(delta: float) -> void:
	# detect change
	player.handle_falling()
	player.handle_jump()
	player.handle_player_movement()
	
	# change states
	if player.move_dir != 0 && player.is_on_floor():
		player.change_state(states.run)
		
	handle_animation()


func handle_animation():
	player.animation_tree["parameters/conditions/is_moving"] = false
	player.animation_tree["parameters/conditions/idle"] = true
	player.animation_tree["parameters/conditions/jump"] = false
	player.animation_tree["parameters/conditions/is_falling"] = false
	player.animation_tree["parameters/conditions/is_die"] = false
	player.handle_flipH()
