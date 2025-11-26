extends Area2D

@export var wind_force: Vector2 = Vector2(1700, 0)
@onready var wind_noise: AudioStreamPlayer = $"../Wind-noise"

func _ready():
	# Connect to body entered/exited signals
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body):
	if body is CharacterBody2D:
		body.apply_wind(wind_force)
		wind_noise.play()


func _on_body_exited(body):
	if body is CharacterBody2D:
		body.remove_wind()
		wind_noise.stop()
