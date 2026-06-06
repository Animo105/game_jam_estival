extends PlayerState
class_name PlayerJumpState

func enter(_previous_state : String)-> void:
	player.jump()

func physics_update(delta:float):
	player.apply_gravity(delta)
	transition()
	
func transition():
	if !player.is_on_floor():
		fsm.change_state("air")
	else:
		fsm.change_state("ground")
