class_name Fall
extends PlayerState


func enter_state() -> void:
	state_name = "Fall"


func exit_state() -> void:
	pass


func update_state(delta: float) -> void:
	player.handle_gravity(delta)
	player.handle_landing()
	handle_animation()


func handle_animation():
	player.animation_tree["parameters/conditions/is_moving"] = false
	player.animation_tree["parameters/conditions/idle"] = false
	player.animation_tree["parameters/conditions/jump"] = false
	player.animation_tree["parameters/conditions/is_falling"] = true
	player.handle_flipH()
