extends PlayerState
class_name DashState

func enter(_previous_state : String)-> void:
	var looking_direction = player.neck.rotation
	print(looking_direction)
