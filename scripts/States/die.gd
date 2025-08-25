class_name Die
extends PlayerState

@onready var die_timer: Timer = $"../../Timers/DieTimer"
@onready var impact_sfx: AudioStreamPlayer = $"../../Sfx/Impact"


const DIE_TIME := 1.0

func enter_state() -> void:
	state_name = "Die"
	player.input_enabled = false
	die_timer.start(DIE_TIME)
	impact_sfx.play()
	if player.global_position.y > 100.0:
		SignalBus.emit_signal("display_dialog", "beginning")
	else:
		SignalBus.emit_signal("display_dialog", "long fall")


func exit_state() -> void:
	player.input_enabled = true


func update_state(delta: float) -> void:
	handle_animation()
	if die_timer.is_stopped():
		player.change_state(states.idle)


func handle_animation():
	player.animation_tree["parameters/conditions/is_moving"] = false
	player.animation_tree["parameters/conditions/idle"] = false
	player.animation_tree["parameters/conditions/jump"] = false
	player.animation_tree["parameters/conditions/is_falling"] = false
	player.animation_tree["parameters/conditions/is_die"] = true
