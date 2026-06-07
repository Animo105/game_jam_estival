extends BasicItem
class_name CombatItem

@export var push_force : int = 6

@export var melee_attack : bool = true
@export var melee_range : Vector3 = Vector3.ONE
@export var melee_animation : Array[Texture]
@export var animation_time : float = 0.3

@export var throwable : bool = true
@export var throw_force : int = 10

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

var exclude_list : Array[Node3D]
var can_attack : bool = true

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
	if not can_attack: return
	var bodies := await Globals.player.get_bodies_in_melee_range(melee_range)
	can_attack = false
	for body in bodies:
		if body is BasicEnemy:
			health -= 1
			body.hit(forward_direction * push_force, damage)
		if body is BasicItem:
			linear_velocity += forward_direction
	Globals.hud_hands.play_once_animation(melee_animation, animation_time)
	await Globals.hud_hands.finished_animation
	can_attack = true

func throw(camera_coods : Vector3, forward_direction : Vector3) -> bool:
	if not throwable : return false
	if not drop_at(camera_coods, forward_direction): return false
	exclude_list.clear()
	apply_impulse(forward_direction * throw_force)
	state = States.THROWN
	return true
