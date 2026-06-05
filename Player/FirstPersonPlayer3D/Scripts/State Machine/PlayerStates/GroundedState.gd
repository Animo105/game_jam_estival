extends PlayerState
class_name PlayerGroundState

const SPEED : float = 2.0
const ACCELERATION : float = 3.0
const DECELERATION : float = 4.0

func physics_update(_delta:float):
	player.move_player(SPEED, ACCELERATION, DECELERATION)
	transition()

func transition():
	# vers running
	if player.inputs.is_running():
		fsm.change_state("run")
	# vers jumping
	elif player.inputs.is_jumping():
		fsm.change_state("jump")
	# vers crouch
	elif player.inputs.is_crouching():
		fsm.change_state('crouch')
	# vers air
	elif !player.is_on_floor():
		fsm.change_state('air')
