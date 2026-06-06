extends BasicItem
class_name CombatItem

@export var spawn_distance : float = 1.0
@export var push_force : int = 6

@export var melee_attack : bool = true
@export var melee_range : Vector3 = Vector3.ONE

@export var throwable : bool = true
@export var throw_force : int = 10

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

var exclude_list : Array[Node3D]

func collision_while_thrown(node : Node3D):
	if not node is BasicEnemy: return
	if exclude_list.has(node) : return
	health -= 1
	node.hit(linear_velocity.normalized() * push_force, damage)
	exclude_list.append(node)

func destroy():
	queue_free()

func use(_camera_coords : Vector3, forward_direction : Vector3):
	if not melee_attack: return
	var bodies := await Globals.player.get_bodies_in_melee_range(melee_range)
	for body in bodies:
		if body is BasicEnemy:
			health -= 1
			body.hit(forward_direction * push_force, damage)
		if body is BasicItem:
			linear_velocity += forward_direction

func reset():
	angular_velocity = Vector3.ZERO
	linear_velocity = Vector3.ZERO
	global_transform.basis = Basis.IDENTITY

func drop_at(camera_coords : Vector3, forward_direction : Vector3) -> bool:
	freeze = true
	Globals.active_object_scene.add_child(self)
	forward_direction.y = 0
	global_position = camera_coords + forward_direction * spawn_distance
	reset()
	if not can_place() :
		get_parent().remove_child(self)
		return false
	freeze = false
	state = States.NORMAL
	return true

func throw(camera_coods : Vector3, forward_direction : Vector3) -> bool:
	if not throwable : return false
	if not drop_at(camera_coods, forward_direction): return false
	exclude_list.clear()
	apply_impulse(forward_direction * throw_force)
	state = States.THROWN
	return true
