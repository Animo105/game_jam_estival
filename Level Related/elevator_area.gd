extends Area3D
class_name ElevatorArea

@export var next_floor : PackedScene

func _ready() -> void:
	if not next_floor: 
		queue_free()
		return
	collision_mask = 2
	body_entered.connect(player_enter)

func player_enter(node : Node3D) -> void:
	if node is Player:
		SceneManager.data["relative_position"] = Globals.player.global_position - global_position
		get_tree().current_scene.remove_child(Globals.player)
		SceneManager.load_from_packed_scene(next_floor)
