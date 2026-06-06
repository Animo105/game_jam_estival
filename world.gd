extends Node3D

@onready var office: Node3D = $Office
@onready var demon_world: Node3D = $DemonWorld

var is_in_office : bool = true

func _ready() -> void:
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
	demon_world.visible = true
	SignalBus.enter_demon_world.emit()

func enable_office():
	is_in_office = true
	Globals.active_object_scene = office
	office.process_mode = Node.PROCESS_MODE_INHERIT
	demon_world.process_mode = Node.PROCESS_MODE_DISABLED
	demon_world.visible = false
	office.visible = true
	SignalBus.enter_office.emit()
