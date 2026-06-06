extends RigidBody3D

class_name BasicItem

@export var health : int = 1
@export var damage : int = 1
@export var texture_in_ui : Texture2D

func _ready() -> void:
	pass

func drop_at(player_coords : Vector3) -> bool:
	return false
