extends PlayerState
class_name PlayercrouchState

const SPEED : float = 1
const ACCELERATION : float = 4.0
const DECELERATION : float = 4.0

func enter(previous_state : String) -> void:
	if previous_state != "slide":
		player.set_crouch(true)

func exit(next_state : String) -> void:
	if next_state != "slide":
		player.set_crouch(false)

func physics_update(delta:float) -> void:
	player.move_player(SPEED, ACCELERATION, DECELERATION)
	player.apply_gravity(delta)
	transition()

func transition() -> void:
	# vers ground
	if !player.inputs.is_crouching() && !player.head_ray.is_colliding():
		fsm.change_state("ground")
	# vers slide
	if player.inputs.is_run_just_pressed():
		fsm.change_state("slide")
