extends RefCounted
class_name PlayerInput

func get_vector() -> Vector2:
	return Input.get_vector("left", "right", "forward", "back")

func is_jumping() -> bool:
	return Input.is_action_pressed("jump")

func is_jump_just_pressed() -> bool:
	return Input.is_action_just_pressed("jump")

func is_dash_just_pressed() -> bool:
	return Input.is_action_just_pressed("dash")
