class_name DialogueVoicePlayer
extends AudioStreamPlayer
	
var _random_number_gen := RandomNumberGenerator.new()
	 
func _ready() -> void:
	_random_number_gen.randomize()
	
func custom_play(from_position := 0.0) -> void:
	set_pitch_scale(_random_number_gen.randf_range(0.95, 1.08))
	play(from_position)
