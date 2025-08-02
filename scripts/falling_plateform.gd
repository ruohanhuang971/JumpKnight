extends Path2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatableBody2D/AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $AnimatableBody2D/CollisionShape2D
var shake_timer: SceneTreeTimer
var respawn_timer: SceneTreeTimer
var time: float = 0.0
var origin: Vector2
var freq: float = 20.0
var amp: float = 1.0


func _ready():
	origin = animated_sprite_2d.global_position


func _process(delta: float) -> void:
	time += delta
	if shake_timer and shake_timer.time_left > 0:
		animated_sprite_2d.global_position.y = origin.y + sin(time * freq) * amp


func plateform_logic() -> void:
	shake_timer = get_tree().create_timer(1.0)
	animated_sprite_2d.play("Break")
	
	await shake_timer.timeout
	animated_sprite_2d.set_visible(false)
	collision_shape_2d.set_disabled(true)
	
	respawn_timer = get_tree().create_timer(5.0)
	await respawn_timer.timeout
	shake_timer = get_tree().create_timer(1.0)
	animated_sprite_2d.play("Idle")
	animated_sprite_2d.set_visible(true)
	collision_shape_2d.set_disabled(false)


func _on_player_detection_area_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		plateform_logic()
