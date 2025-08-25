extends Control

@onready var option_menu: Control = $OptionMenu

var _is_paused: bool = false:
	set = set_paused


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_is_paused = !_is_paused


func set_paused(value:bool) -> void:
	print(value)
	_is_paused = value
	get_tree().paused = _is_paused
	visible = _is_paused
	SignalBus.emit_signal("pause", _is_paused)
	if _is_paused:
		option_menu.visible = false


func get_paused() -> bool:
	return _is_paused


func _on_continue_pressed() -> void:
	_is_paused = false


func _on_option_pressed() -> void:
	option_menu.visible = true


func _on_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
