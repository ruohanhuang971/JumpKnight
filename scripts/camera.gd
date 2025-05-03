extends Camera2D

@onready var player: CharacterBody2D = $"../player"
const camera_lead := 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y = player.position.y - camera_lead
