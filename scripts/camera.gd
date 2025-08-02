extends Camera2D

@onready var player: CharacterBody2D = $"../player"
const camera_lead := 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x = player.position.x
	position.y = player.position.y - camera_lead
