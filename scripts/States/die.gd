class_name Die
extends PlayerState

@export var dialog_key := "long fall"

@onready var die_timer: Timer = $"../../Timers/DieTimer"
@onready var impact_sfx: AudioStreamPlayer = $"../../Sfx/Impact"


const DIE_TIME := 1.0

func enter_state() -> void:
	state_name = "Die"
	player.input_enabled = false
	die_timer.start(DIE_TIME)
	impact_sfx.play()
	SignalBus.emit_signal("display_dialog", dialog_key)


func exit_state() -> void:
	player.input_enabled = true


func update_state(delta: float) -> void:
	handle_animation()
	if die_timer.is_stopped():
		player.change_state(states.idle)
	#print(die_timer.get_time_left())


func handle_animation():
	player.animation_tree["parameters/conditions/is_moving"] = false
	player.animation_tree["parameters/conditions/idle"] = false
	player.animation_tree["parameters/conditions/jump"] = false
	player.animation_tree["parameters/conditions/is_falling"] = false
	player.animation_tree["parameters/conditions/is_die"] = true
