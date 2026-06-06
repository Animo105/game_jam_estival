extends Node3D
class_name Level

var office_environement : Environment
var demon_environement : Environment

@export var office: Node3D
@export var demon_world: Node3D

@export var starting_elevator : StartingElevator

var world_environement : WorldEnvironment = WorldEnvironment.new()
var is_in_office : bool = true

func _ready() -> void:
	office_environement = load("res://Assets/Environements/office_environement.tres")
	demon_environement = load("res://Assets/Environements/demon_world_environement.tres")
	add_child(world_environement)
	enable_office()
	if starting_elevator:
		add_child(Globals.player)
		Globals.player.global_position = starting_elevator.to_global(SceneManager.data["relative_position"])
		Globals.player.visual.global_transform = starting_elevator.global_transform * SceneManager.data["relative_transform"]
		starting_elevator.open_door()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("swap"):
		if is_in_office:
			enable_demon_world()
		else:
			enable_office()

func enable_demon_world():
	is_in_office = false
	Globals.active_object_scene = demon_world
	demon_world.process_mode = Node.PROCESS_MODE_INHERIT
	office.process_mode = Node.PROCESS_MODE_DISABLED
	office.visible = false
	world_environement.environment = demon_environement
	demon_world.visible = true
	SignalBus.enter_demon_world.emit()

func enable_office():
	is_in_office = true
	Globals.active_object_scene = office
	office.process_mode = Node.PROCESS_MODE_INHERIT
	demon_world.process_mode = Node.PROCESS_MODE_DISABLED
	demon_world.visible = false
	world_environement.environment = office_environement
	office.visible = true
	SignalBus.enter_office.emit()
