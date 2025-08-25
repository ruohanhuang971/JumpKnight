extends Control
@onready var option_menu: Control = $OptionMenu
@onready var button: Button = $VBoxContainer/Button
@onready var button_2: Button = $VBoxContainer/Button2
@onready var button_3: Button = $VBoxContainer/Button3



func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_option_pressed() -> void:
	option_menu.visible = true


func _on_exit_pressed() -> void:
	get_tree().quit()
