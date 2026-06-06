extends RigidBody3D

const MOUSE_SENSITIVITY : float = 0.2

const DEFAULT_SPEED : float = 4.0
const DEFAULT_ACCELERATION : float = 3.0
const DEFAULT_DECELERATION : float = 4.0
const DEFAULT_FOV : float = 75.0

const DASH_STRENGHT : float = 30.0

const JUMP_VELOCITY : float = 6.0

@onready var visual: Node3D = $Visual
@onready var neck: Node3D = $Visual/Neck
@onready var camera: Camera3D = $Visual/Neck/Camera
@onready var feet_ray_cast: RayCast3D = $FeetRayCast

var is_grounded : bool = false
var inputs : PlayerInput = PlayerInput.new()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if event is InputEventMouseMotion:
		if not Input.mouse_mode == Input.MOUSE_MODE_CAPTURED: return # si mouse pas capture, empêche de bouger
		_update_camera(-event.relative.x, -event.relative.y)

func _update_camera(mouse_x : float, mouse_y : float):
	visual.rotate_y(deg_to_rad(mouse_x * MOUSE_SENSITIVITY)) # rotate sur y axis le personnage (left/right)
	neck.rotate_x(deg_to_rad(mouse_y * MOUSE_SENSITIVITY)) # rotate sur x axis la camera (up/down)
	neck.rotation.x = clamp(neck.rotation.x, deg_to_rad(-70), deg_to_rad(70)) # clamp la rotation

func _physics_process(_delta: float) -> void:
	handle_movement()
	handle_dash()
	handle_jumping()

func handle_movement(speed : float = DEFAULT_SPEED, acceleration : float = DEFAULT_ACCELERATION, deceleration : float = DEFAULT_DECELERATION)->void:
	var input_dir : Vector2 = inputs.get_vector()
	var direction : Vector3 = (visual.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		linear_velocity.x = move_toward(linear_velocity.x, direction.x * speed, acceleration)
		linear_velocity.z = move_toward(linear_velocity.z, direction.z * speed, acceleration)
	else:
		linear_velocity.x = move_toward(linear_velocity.x, 0, deceleration)
		linear_velocity.z = move_toward(linear_velocity.z, 0, deceleration)

func handle_dash():
	if inputs.is_dash_just_pressed():
		var input_dir : Vector2 = inputs.get_vector()
		var camera_direction : Vector3 = camera.global_transform.basis * Vector3.FORWARD
		var direction : Vector3 = (visual.transform.basis * Vector3(input_dir.x, camera_direction.y, input_dir.y)).normalized()
		apply_impulse(direction * DASH_STRENGHT)

func handle_jumping():
	if not is_grounded:
		if feet_ray_cast.is_colliding():
			if inputs.is_jumping():
				jump()
			else:
				is_grounded = true
	else:
		if not feet_ray_cast.is_colliding():
			is_grounded = false
		if inputs.is_jump_just_pressed():
			jump()

func jump():
	linear_velocity.y = JUMP_VELOCITY
