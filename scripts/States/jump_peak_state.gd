class_name JumpPeak
extends PlayerState


func enter_state() -> void:
	state_name = "JumpPeak"


func exit_state() -> void:
	pass


func update_state(delta: float) -> void:
	player.handle_falling()
	
	player.change_state(states.fall)
