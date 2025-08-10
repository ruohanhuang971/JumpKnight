class_name Dialogue
extends CanvasLayer
 
@onready var content: RichTextLabel = $Content
@onready var type_timer: Timer = $TypeTimer
@onready var pause_timer: Timer = $PauseTimer
@onready var voice_player : AudioStreamPlayer = $AudioStreamPlayer

@export_file("*json") var scene_text_file: String = "res://assets/Json/text.json"

var _playing_voice := false
var in_progress := false
var scene_text: Dictionary = {}
var selected_text: Array = []
var _random_number_gen := RandomNumberGenerator.new()
var index := -1


func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	scene_text = load_scene_text()
	SignalBus.connect("display_dialog", Callable(self, "on_display_dialog"))
 

func load_scene_text():
	if FileAccess.file_exists(scene_text_file):
		var file = FileAccess.open(scene_text_file, FileAccess.READ)
		var test_json_conv = JSON.new()
		test_json_conv.parse(file.get_as_text())
		return test_json_conv.get_data()


func show_text():
	var new_index = _random_number_gen.randf_range(0, selected_text.size())
	while new_index == index: 
		new_index = _random_number_gen.randf_range(0, selected_text.size())
	index = new_index
	var line = selected_text[new_index]
	update_message(line)


func next_line():
	if selected_text.size() > 0:
		show_text()
	else:
		finish()


func finish():
	content.text = ""
	voice_player.stop()


func on_display_dialog(text_key):
	if in_progress:
		next_line()
	else:
		in_progress = true
		selected_text = scene_text[text_key].duplicate()
		show_text()



# Update the message and starts typing
func update_message(message: String) -> void:
	content.bbcode_text = message
	content.visible_characters = 0
	type_timer.start()
	_playing_voice = true
	voice_player.custom_play(0)


func _on_type_typer_timeout() -> void:
	if content.visible_characters < content.text.length():
		content.visible_characters += 1
	else:
		type_timer.stop()
		_playing_voice = false
		voice_player.stop()
		pause_timer.start()


func _on_audio_stream_player_finished() -> void:
	if _playing_voice:
		voice_player.custom_play(0)


func _on_pause_timer_timeout() -> void:
	content.text = ""
