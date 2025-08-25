extends CharacterBody2D

#region Player Var
# Nodes
@onready var sprite_2d: Sprite2D = $"Knight-idle"
@onready var camera_2d: Camera2D = $Camera2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: Node = $StateMachine

@onready var coyote_timer: Timer = $Timers/CoyoteTimer
@onready var jump_buffer_timer: Timer = $Timers/JumpBufferTimer

@onready var ray_cast_left: RayCast2D = $RayCast/RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCast/RayCastRight

@onready var fall_sfx: AudioStreamPlayer = $Sfx/Fall

@onready var pause_menu: Control = $"../CanvasLayer/PauseMenu"

# Physics variables
const RUN_SPEED := 300
const ACCELERATION := 30
const DECELERATION := 50
const AIR_ACCELERATION := 20
const AIR_DECELERATION := 30
const GRAVITY_JUMP := 1500
const GRAVITY_FALL := 3000
const MAX_FALL_VELOCITY := 1500
const JUMP_VELOCITY = -650
const JUMP_MULTIPLIER = 0.5
const MAX_JUMP = 1

const JUMP_BUFFER_TIME := 0.15
const COYOTE_TIMER := 0.1

var move_speed := RUN_SPEED
var jump_speed := JUMP_VELOCITY
var prev_velocity:Vector2 = Vector2.ZERO
var move_dir := 0
var facing := 1
var jumps := 0

# Input variables
var input_enabled := true
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

var past_height := 0 
const DIE_HEIGHT := 500

const WALL_PUSH := 30

var paused: bool = false

#endregion


func _ready() -> void:
	# load position
	#var pos = Save.load_data()
	#global_position = pos
	#SignalBus.connect("pause", Callable(self, "on_pause"))
	
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
		
		#var message: String = "Change state from " + str(previous_state) + " to " + str(current_state)
		#print(message)


func _physics_process(delta: float) -> void:
	get_input_state()
	
	current_state.update_state(delta)
	
	handle_fall_velocity()
	handle_wall_bump()
	handle_player_movement()
	handle_jump()
	
	move_and_slide()
	
	prev_velocity = velocity


func get_input_state():
	if input_enabled:
		key_left = Input.is_action_pressed("move_left")
		key_right = Input.is_action_pressed("move_right")
		key_jump = Input.is_action_pressed("jump")
		key_jump_pressed = Input.is_action_just_pressed("jump")
		
		if key_left: 
			facing = Facing.LEFT
		if key_right: 
			facing = Facing.RIGHT
	else:
		key_up = false
		key_down = false
		key_left = false
		key_right = false
		key_jump = false
		key_jump_pressed = false


func handle_gravity(delta: float, gravity: float = GRAVITY_JUMP):
	if abs(velocity.y) < 50:
		gravity *= 0.95
	if not is_on_floor():
		velocity.y += gravity * delta

func handle_player_movement():
	if not input_enabled:
		velocity.x = 0
		return
	move_dir = Input.get_axis("move_left", "move_right")
	if move_dir != 0:
		if not is_on_floor():
			velocity.x = move_toward(velocity.x, move_dir * move_speed, AIR_ACCELERATION)
		else:
			velocity.x = move_toward(velocity.x, move_dir * move_speed, ACCELERATION)
	else:
		if not is_on_floor():
			velocity.x = move_toward(velocity.x, move_dir * move_speed, AIR_DECELERATION)
		else:
			velocity.x = move_toward(velocity.x, move_dir * move_speed, DECELERATION)

func handle_jump():
	if is_on_floor():
		if jumps < MAX_JUMP:
			if key_jump_pressed or jump_buffer_timer.time_left > 0:
				jumps += 1
				jump_buffer_timer.stop()
				change_state(state_machine.jump)
	else:
		if coyote_timer.time_left > 0:
			if key_jump_pressed and jumps < MAX_JUMP:
				coyote_timer.stop()
				jumps += 1
				change_state(state_machine.jump)

func handle_falling():
	if not is_on_floor():
		coyote_timer.start(COYOTE_TIMER)
		change_state(state_machine.fall)
		past_height = position.y

func handle_landing():
	if is_on_floor():
		fall_sfx.play()
		jumps = 0
		var cur_height := position.y
		if ((cur_height - past_height) > DIE_HEIGHT):
			change_state(state_machine.die)
		else:
			if (current_state != state_machine.idle):
				change_state(state_machine.idle)

func handle_flipH():
	if facing == Facing.LEFT:
		sprite_2d.flip_h = true
	else:
		sprite_2d.flip_h = false

func handle_fall_velocity():
	if velocity.y > MAX_FALL_VELOCITY:
		velocity.y = MAX_FALL_VELOCITY

func handle_jump_buffer():
	if key_jump_pressed:
		jump_buffer_timer.start(JUMP_BUFFER_TIME)

func handle_wall_bump():
	if not is_on_floor() and velocity.y < 0:
		if ray_cast_left.is_colliding():
			velocity.x += WALL_PUSH
		elif ray_cast_right.is_colliding():
			velocity.x -= WALL_PUSH

func on_pause(is_paused):
	print("Pause signal received:", is_paused)
	if is_paused:
		Save.save(position)
	else:
		global_position = Save.load_data()

# save position
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		Save.save(global_position)
		get_tree().quit()
