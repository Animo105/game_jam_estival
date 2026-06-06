extends Node3D
class_name StartingElevator

@onready var door_shape: CollisionShape3D = $ElevatorDoor/DoorShape
@onready var elevator_mesh: MeshInstance3D = $Elevator/ElevatorMesh
var tween : Tween

func open_door():
	door_shape.disabled = true
	if tween: tween.kill()
	tween = create_tween()
	tween.tween_property(elevator_mesh, "blend_shapes/Open", 1, 0.3)
