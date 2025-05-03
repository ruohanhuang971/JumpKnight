extends CharacterBody2D

#region Player Var
# Nodes
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var jump_height_timer: Timer = $JumpHeightTimer
@onready var camera_2d: Camera2D = $Camera2D
@onready var state_machine: Node = $StateMachine

# Physics variables
const RUN_SPEED := 300
const ACCELERATION := 30
const DECELERATION := 50
const GRAVITY := 1500
const JUMP_VELOCITY = -600
const MAX_JUMP = 1

var move_speed := RUN_SPEED
var jump_speed := JUMP_VELOCITY
var move_dir := 0
var facing := 1
var jumps := 0

# Input variables
var key_up := false
var key_down := false
var key_left := false
var key_right := false
var key_jump := false
var key_jump_pressed := false

# state machine variables
var current_state = null
var previous_state = null

enum Facing {
	LEFT = 1,
	RIGHT = -1
}

var is_jumping := false
var is_falling := false
var jump_buffer_triggered := false

#endregion


func _ready() -> void:
	# init animation tree
	animation_tree.active = true
	
	# init state machine
	for state in state_machine.get_children():
		state.states = state_machine
		state.player = self
	previous_state = state_machine.fall
	current_state = state_machine.fall


func change_state(next_state):
	if next_state != null:
		previous_state = current_state
		current_state = next_state
		previous_state.exit_state()
		current_state.enter_state()
		
		var message: String = "Change state from " + str(previous_state) + " to " + str(current_state)
		print(message)


func _physics_process(delta: float) -> void:	
	get_input_state()
	
	current_state.update_state(delta)
	
	handle_player_movement()
	handle_jump()
	
	move_and_slide()


func get_input_state():
	key_left = Input.is_action_pressed("move_left")
	key_right = Input.is_action_pressed("move_right")
	key_jump = Input.is_action_pressed("jump")
	key_jump_pressed = Input.is_action_just_pressed("jump")
	
	if key_left: 
		facing = Facing.LEFT
	if key_right: 
		facing = Facing.RIGHT


func handle_gravity(delta: float, gravity: float = GRAVITY):
	if not is_on_floor():
		velocity.y += GRAVITY * delta

func handle_player_movement():
	move_dir = Input.get_axis("move_left", "move_right")
	if move_dir != 0:
		velocity.x = move_toward(velocity.x, move_dir * move_speed, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, move_dir * move_speed, DECELERATION)

func handle_jump():
	if key_jump_pressed and jumps < MAX_JUMP:
		jumps += 1
		change_state(state_machine.jump)

func handle_falling():
	if not is_on_floor():
		change_state(state_machine.fall)

func handle_landing():
	if is_on_floor():
		jumps = 0
		change_state(state_machine.idle)

func handle_flipH():
	if facing == Facing.LEFT:
		sprite_2d.flip_h = true
	else:
		sprite_2d.flip_h = false
