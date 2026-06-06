extends PlayerState
class_name PlayerGroundState

const SPEED : float = 2.0
const ACCELERATION : float = 3.0
const DECELERATION : float = 4.0

func physics_update(_delta:float):
	player.move_player(SPEED, ACCELERATION, DECELERATION)
	transition()

func transition():
	# vers jumping
	if player.inputs.is_jumping():
		fsm.change_state("jump")
	# vers dash
	elif player.inputs.is_dash_just_pressed():
		fsm.change_state("dash")
	# vers air
	elif !player.is_on_floor():
		fsm.change_state("air")
