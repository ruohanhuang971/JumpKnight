extends PlayerState
@onready var jump_sfx: AudioStreamPlayer = $"../../Sfx/Jump"


func enter_state() -> void:
	state_name = "Jump"
	player.velocity.y = player.jump_speed
	jump_sfx.play()


func exit_state() -> void:
	pass


func update_state(delta: float) -> void:
	player.handle_gravity(delta)
	player.handle_player_movement()
	handle_jump_to_fall()
	handle_animation()


func handle_jump_to_fall():
	if player.velocity.y >= 0:
		player.change_state(states.jump_peak)
	if not player.key_jump:
		player.velocity.y *= player.JUMP_MULTIPLIER
		player.change_state(states.jump_peak)


func handle_animation():
	player.animation_tree["parameters/conditions/is_moving"] = false
	player.animation_tree["parameters/conditions/idle"] = false
	player.animation_tree["parameters/conditions/jump"] = true
	player.animation_tree["parameters/conditions/is_falling"] = false
	player.animation_tree["parameters/conditions/is_die"] = false
	player.handle_flipH()
