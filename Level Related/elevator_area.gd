extends Node3D
class_name ElevatorArea


@export var next_floor : PackedScene
@export var enemies_to_kill : int = 0

@onready var door_shape: CollisionShape3D = $ElevatorDoor/DoorShape
@onready var area_shape: CollisionShape3D = $Area3D/AreaShape
@onready var elevator_mesh: MeshInstance3D = $Elevator/ElevatorMesh
@onready var count_label: Label3D = $Count_label
@onready var timer: Timer = $Timer

var kill_count : int = 0
var tween : Tween

func _ready() -> void:
	door_shape.disabled = false
	count_label.text = "[%s/%s]" % [kill_count,enemies_to_kill]
	SignalBus.enemy_death.connect(enemy_killed)
	if enemies_to_kill == 0:
		open_door()

func enemy_killed():
	kill_count += 1
	count_label.text = "[%s/%s]" % [kill_count,enemies_to_kill]
	if kill_count >= enemies_to_kill:
		open_door()

func open_door():
	door_shape.disabled = true
	count_label.visible = false
	if tween: tween.kill()
	tween = create_tween()
	tween.tween_property(elevator_mesh, "blend_shapes/Open", 1, 0.3)

func _on_elevator_area_body_entered(body: Node3D) -> void:
	if body is Player:
		door_shape.disabled = false
		area_shape.disabled = true
		if tween: tween.kill()
		tween = create_tween()
		tween.tween_property(elevator_mesh, "blend_shapes/Open", 0, 0.3)
		timer.start(1)
		await timer.timeout
		if next_floor:
			swap_player()
		else:
			open_door()

func swap_player():
	SwapManager.lock_in_office()
	SceneManager.data["relative_position"] = to_local(Globals.player.global_position)
	SceneManager.data["relative_transform"] = global_transform.affine_inverse() * Globals.player.visual.global_transform
	get_tree().current_scene.remove_child(Globals.player)
	SceneManager.load_from_packed_scene(next_floor)
