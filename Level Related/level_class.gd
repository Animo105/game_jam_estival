extends Node3D
class_name Level

@export var office_environement : Environment
@export var demon_environement : Environment

@export var office: Node3D
@export var demon_world: Node3D

@export var starting_elevator : Node3D

var world_environement : WorldEnvironment = WorldEnvironment.new()
var is_in_office : bool = true

func _ready() -> void:
	if starting_elevator:
		var player_global_position =  SceneManager.data["relative_position"] + starting_elevator.global_position
		add_child(Globals.player)
		Globals.player.global_position = player_global_position
	add_child(world_environement)
	enable_office()

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
