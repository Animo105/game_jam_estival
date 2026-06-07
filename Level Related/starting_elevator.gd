extends Node3D
class_name StartingElevator

@onready var door_shape: CollisionShape3D = $ElevatorDoor/DoorShape
@onready var elevator_mesh: MeshInstance3D = $Elevator/ElevatorMesh
@onready var count_down_label: Label3D = $count_down
var tween : Tween

var count_down : int = 3:
	set(value):
		count_down = value
		if count_down_label:
			count_down_label.text = str(value)

func open_door():
	count_down = 3
	door_shape.disabled = true
	if tween: tween.kill()
	tween = create_tween()
	tween.tween_property(Globals.player, "health", Player.STARTING_LIFE, 2)
	tween.tween_property(self, "count_down", 0, 3)
	tween.tween_property(elevator_mesh, "blend_shapes/Open", 1, 0.3)
	await tween.finished
	SwapManager.restart_timer()
