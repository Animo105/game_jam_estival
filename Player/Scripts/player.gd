extends CharacterBody3D
class_name Player

@onready var neck: Node3D = $neck
@onready var camera: Camera3D = $neck/camera
@onready var collision_shape: CollisionShape3D = $CollisionShape

@onready var fsm: PlayerFSM = $PlayerFSM
var inputs : PlayerInput = PlayerInput.new()

const MOUSE_SENSITIVITY : float = 0.2

const DEFAULT_SPEED : float = 4
const DEFAULT_ACCELERATION : float = 3.0
const DEFAULT_DECELERATION : float = 4.0
const DEFAULT_FOV : float = 75

const MAX_DASH_DISTANCE : float = 2

const JUMP_VELOCITY : float = 4

var starting_position : Vector3
var starting_transform : Transform3D
var last_direction : Vector3 = Vector3(0,0,0)

func reset() -> void:
	global_position = starting_position
	transform = starting_transform

func _ready() -> void:
	starting_position = global_position
	starting_transform = transform
	reset()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
	fsm.update(delta)
	camera.fov = lerp(camera.fov, get_speed()+DEFAULT_FOV, 0.2)

func _physics_process(delta: float) -> void:
	fsm.physics_update(delta)
	move_and_slide()

func is_moving()->bool:
	return not velocity.x == 0 or not velocity.z == 0

func get_speed()->float:
	return velocity.length()

func jump()->void:
	velocity.y = JUMP_VELOCITY

func move_player(speed : float = DEFAULT_SPEED, acceleration : float = DEFAULT_ACCELERATION, deceleration : float = DEFAULT_DECELERATION)->void:
	var input_dir := inputs.get_vector()
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * speed, acceleration)
		velocity.z = move_toward(velocity.z, direction.z * speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration)
		velocity.z = move_toward(velocity.z, 0, deceleration)
	last_direction = direction

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if event is InputEventMouseMotion:
		if not Input.mouse_mode == Input.MOUSE_MODE_CAPTURED: return # si mouse pas capture, empêche de bouger
		_update_camera(-event.relative.x, -event.relative.y)

func _update_camera(mouse_x : float, mouse_y : float):
	rotate_y(deg_to_rad(mouse_x * MOUSE_SENSITIVITY)) # rotate sur y axis le personnage (left/right)
	neck.rotate_x(deg_to_rad(mouse_y * MOUSE_SENSITIVITY)) # rotate sur x axis la camera (up/down)
	neck.rotation.x = clamp(neck.rotation.x, deg_to_rad(-70), deg_to_rad(70)) # clamp la rotation

func apply_gravity(delta : float)->void:
	velocity += get_gravity() * delta

func update_velocity() -> void:
	velocity.x = move_toward(velocity.x, 0, DEFAULT_DECELERATION)
	velocity.z = move_toward(velocity.z, 0, DEFAULT_DECELERATION)
