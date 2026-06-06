extends RigidBody3D

class_name BasicItem

@export var health : int = 1
@export var damage : int = 1
@export var texture_in_ui : Texture2D

enum States {NORMAL, THROWN}
var state : States = States.NORMAL

func _init() -> void:
	contact_monitor = true
	max_contacts_reported = 1

func _physics_process(_delta: float) -> void:
	if not state == States.THROWN: return
	if not get_colliding_bodies().is_empty():
		collision_while_thrown(get_colliding_bodies()[0])
	if linear_velocity.length() < 0.5 :
		state = States.NORMAL


@warning_ignore("unused_parameter")
func collision_while_thrown(node : Node3D):
	pass

func can_place() -> bool:
	var space_state : PhysicsDirectSpaceState3D = Globals.active_object_scene.get_world_3d().direct_space_state
	var collision : CollisionShape3D = $CollisionShape3D
	if not collision: return false
	var shape : Shape3D = collision.shape
	var query : PhysicsShapeQueryParameters3D = PhysicsShapeQueryParameters3D.new()
	query.shape = shape
	query.transform = Transform3D(global_basis, global_position)
	query.exclude = [self]
	query.collision_mask = 1
	var results  := space_state.intersect_shape(query)
	return results.is_empty()  # true = peut placer, false = collision

func _ready() -> void:
	pass

@warning_ignore("unused_parameter")
func drop_at(camera_coords : Vector3, forward_direction : Vector3) -> bool:
	return false

@warning_ignore("unused_parameter")
func throw(camera_coods : Vector3, forward_direction : Vector3) -> bool:
	return false
