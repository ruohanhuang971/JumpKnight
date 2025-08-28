extends Node2D

var save_path = "user://variable.save"
var player_pos := Vector2(-117.0, 129.0)

var volume: float = 100
var resolution_index: int = 0

func _ready() -> void:
	get_tree().auto_accept_quit = false


func start() -> void:
	pass
	#load_data()


func save(position: Vector2):
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(position)


func load_data() -> Vector2:
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		return file.get_var()
	else:
		return Vector2(-117.0, 129.0)


func reset():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(Vector2(-117.0, 129.0))
