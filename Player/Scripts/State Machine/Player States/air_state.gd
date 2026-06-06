extends PlayerState
class_name PlayerAirState

const SPEED : float = 2
const ACCELERATION : float = 0.2
const DECELERATION : float = 0.4

func physics_update(delta:float) -> void:
	player.apply_gravity(delta)
	player.move_player(SPEED, ACCELERATION, DECELERATION)
	transition()
	
func transition():
	if player.is_on_floor():
		fsm.change_state('ground')
	# vers dash
	elif player.inputs.is_dash_just_pressed():
		fsm.change_state("dash")
