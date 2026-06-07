extends RigidBody3D
class_name Player

const MOUSE_SENSITIVITY : float = 0.2

const DEFAULT_SPEED : float = 4.0
const DEFAULT_ACCELERATION : float = 3.0
const DEFAULT_DECELERATION : float = 4.0
const DEFAULT_FOV : float = 75.0

const DASH_STRENGHT : float = 30.0

const JUMP_VELOCITY : float = 10.0

const STARTING_LIFE : int = 5

# SFX
var footstep_timer: float = 0.0
const FOOTSTEP_INTERVAL: float = 0.3

@onready var visual: Node3D = $Visual
@onready var neck: Node3D = $Visual/Neck
@onready var camera: Camera3D = $Visual/Neck/Camera
@onready var feet_ray_cast: RayCast3D = $FeetRayCast
@onready var melee_area: Area3D = $Visual/Neck/Camera/MeleeArea
@onready var range_collision_shape: CollisionShape3D = $Visual/Neck/Camera/MeleeArea/CollisionShape3D


var is_grounded : bool = false
var inputs : PlayerInput = PlayerInput.new()
var can_dash : bool = true

var reset_transform : Transform3D
var health : int = 5:
	set = _set_health

func set_position_for_reset():
	reset_transform = global_transform

func reset():
	global_transform = reset_transform
	health = STARTING_LIFE

func _set_health(value : int) -> void:
	var is_decreasing : bool = (value - health) < 0
	health = value
	if health <= 0:
		reset()
		SignalBus.player_death.emit()
		get_parent().remove_child.call_deferred(self)
		get_tree().call_deferred("reload_current_scene")
	else:
		SignalBus.player_life_changing.emit(value, is_decreasing)

func _ready() -> void:
	Globals.player = self

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

func _physics_process(delta: float) -> void:
	handle_movement()
	handle_dash()
	handle_jumping()
	handle_footsteps(delta)

func handle_footsteps(delta: float) -> void:
	var horizontal_speed := Vector2(linear_velocity.x, linear_velocity.z).length()

	if is_grounded and horizontal_speed > 1.0:
		footstep_timer -= delta

		if footstep_timer <= 0.0:
			Vfx.play(Vfx.Sound.STEP, 23)
			footstep_timer = FOOTSTEP_INTERVAL
	else:
		footstep_timer = 0.0

func handle_movement(speed : float = DEFAULT_SPEED, acceleration : float = DEFAULT_ACCELERATION, deceleration : float = DEFAULT_DECELERATION)->void:
	var input_dir : Vector2 = inputs.get_vector()
	var direction : Vector3 = (visual.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		linear_velocity.x = move_toward(linear_velocity.x, direction.x * speed, acceleration)
		linear_velocity.z = move_toward(linear_velocity.z, direction.z * speed, acceleration)
	else:
		linear_velocity.x = move_toward(linear_velocity.x, 0, deceleration)
		linear_velocity.z = move_toward(linear_velocity.z, 0, deceleration)

func get_bodies_in_melee_range(melee_range : Vector3) -> Array[Node3D]:
	range_collision_shape.shape.size = melee_range
	range_collision_shape.position.z = -melee_range.z/2
	await get_tree().physics_frame
	return melee_area.get_overlapping_bodies()

func handle_dash():
	if not can_dash: 
		if is_grounded: can_dash = true
		else: return
	if inputs.is_dash_just_pressed():
		Vfx.play(Vfx.Sound.DASH)
		var input_dir : Vector2 = inputs.get_vector()
		var camera_direction : Vector3 = -camera.global_transform.basis.z
		var direction : Vector3 = Vector3.ZERO
		if input_dir.length() < 0.2 :
			direction = camera_direction.normalized()
		else:
			direction = (visual.transform.basis * Vector3(input_dir.x, camera_direction.y, input_dir.y)).normalized()
		apply_impulse(direction * DASH_STRENGHT)
		can_dash = false

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
