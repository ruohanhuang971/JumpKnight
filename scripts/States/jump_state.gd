extends PlayerState


func enter_state() -> void:
	state_name = "Jump"
	player.velocity.y = player.jump_speed


func exit_state() -> void:
	pass


func update_state(delta: float) -> void:
	player.handle_gravity(delta)
	handle_jump_to_fall()
	handle_animation()


func handle_jump_to_fall():
	if player.velocity.y >= 0:
		player.change_state(states.jump_peak)


func handle_animation():
	player.animation_tree["parameters/conditions/is_moving"] = false
	player.animation_tree["parameters/conditions/idle"] = false
	player.animation_tree["parameters/conditions/jump"] = true
	player.animation_tree["parameters/conditions/is_falling"] = false
	player.handle_flipH()
