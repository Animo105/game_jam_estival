extends PlayerState
class_name PlayerRunState

const SPEED : float = 4.0
const ACCELERATION : float = 6.0
const DECELERATION : float = 8.0
var tilt_tween : Tween


func physics_update(_delta:float):
	player.move_player(SPEED, ACCELERATION, DECELERATION)
	transition()
	
func enter(_previous_state : String)-> void:
	player.basic_fov += 10

func exit(_next_state : String)-> void:
	player.basic_fov -= 10
	var tween : Tween = create_tween()
	tween.tween_property(player.camera, "rotation", Vector3(player.camera.rotation.x,player.camera.rotation.y,0), 0.2)

func transition():
	# vers ground si forwad n'est plus pressed
	if !Input.is_action_pressed("forward"):
		fsm.change_state("ground")
	# vers ground si pu running
	elif !player.inputs.is_running():
		fsm.change_state("ground")
	# vers slide
	elif player.inputs.is_crouching():
			fsm.change_state('slide')
	# vers air si pu on floor
	elif !player.is_on_floor():
		fsm.change_state('air')
	elif player.inputs.is_jump_just_pressed():
		fsm.change_state("jump")
