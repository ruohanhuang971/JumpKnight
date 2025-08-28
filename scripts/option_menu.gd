extends Control

var save_path = "user://variable.save"
@onready var resolution_dropdown: OptionButton = $Resolution/OptionButton
@onready var volume_slider: HSlider = $Audio/HSlider

func _ready():
	# Sync UI from stored values
	volume_slider.value = Save.volume
	var db = linear_to_db(volume_slider.value)
	AudioServer.set_bus_volume_db(0, db)
	resolution_dropdown.select(Save.resolution_index)


func _on_volume_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	print(value, db)
	AudioServer.set_bus_volume_db(0, db)
	Save.volume = value


func _on_option_button_item_selected(index: int) -> void:
	Save.resolution_index = index
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_size(Vector2i(1600, 900))
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_size(Vector2i(1280, 720))
		3:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _on_restart_pressed() -> void:
	Save.reset()


func _on_back_pressed() -> void:
	visible = false
