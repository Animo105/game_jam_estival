extends PlayerState
class_name PlayerSlideState
@onready var camera: Camera3D = $"../../neck/camera"

const ACCELERATION = 15
const DECELERATION = 10
var dir : Vector3

func enter(previous_state : String)-> void:
	dir = player.last_direction
	player.velocity = dir * ACCELERATION
	if previous_state != "crouch":
		player.set_crouch(true)

func exit(next_state : String)-> void:
	if next_state != "crouch":
		player.set_crouch(false)

func physics_update(delta:float):
	player.velocity.x = move_toward(player.velocity.x, 0, DECELERATION * delta)
	player.velocity.z = move_toward(player.velocity.z, 0, DECELERATION * delta)
	transition()
	
func transition():
	if !player.is_moving():
		fsm.change_state("crouch")
		
	elif !player.inputs.is_crouching():
		fsm.change_state("ground")
	
	elif !player.is_on_floor():
		fsm.change_state("air")
