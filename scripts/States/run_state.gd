class_name RunState
extends PlayerState
@onready var run_sfx: AudioStreamPlayer = $"../../Sfx/Run"


func enter_state() -> void:
	state_name = "Run"
	run_sfx.play()


func exit_state() -> void:
	run_sfx.stop()


func update_state(delta: float) -> void:
	# detect change
	player.handle_falling()
	player.handle_jump()
	player.handle_player_movement()
	
	# change state
	if player.move_dir == 0:
		player.change_state(states.idle)
		
	handle_animation()


func handle_animation():
	player.animation_tree["parameters/conditions/is_moving"] = true
	player.animation_tree["parameters/conditions/idle"] = false
	player.animation_tree["parameters/conditions/jump"] = false
	player.animation_tree["parameters/conditions/is_falling"] = false
	player.animation_tree["parameters/conditions/is_die"] = false
	player.handle_flipH()
