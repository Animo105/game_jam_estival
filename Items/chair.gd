extends BasicItem

@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

func drop_at(camera_coords : Vector3, forward_direction : Vector3) -> bool:
	freeze = true
	Globals.active_object_scene.add_child(self)
	global_position = camera_coords + forward_direction * 0.7
	angular_velocity = Vector3.ZERO
	linear_velocity = Vector3.ZERO
	global_transform.basis = Basis.IDENTITY
	if not can_place() :
		get_parent().remove_child(self)
		return false
	freeze = false
	return true
	
