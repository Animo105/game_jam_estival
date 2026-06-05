extends RefCounted
class_name PlayerInput

func get_vector() -> Vector2:
	return Input.get_vector("left", "right", "forward", "back")

func is_jumping() -> bool:
	return Input.is_action_pressed("jump")

func is_jump_just_pressed() -> bool:
	return Input.is_action_just_pressed("jump")

func is_running() -> bool:
	return Input.is_action_pressed("dash")

func is_run_just_pressed() -> bool:
	return Input.is_action_just_pressed("dash")

func is_crouching() -> bool:
	return Input.is_action_pressed("ui_text_backspace")

func is_crouch_just_pressed() -> bool:
	return Input.is_action_just_pressed("ui_text_backspace")
