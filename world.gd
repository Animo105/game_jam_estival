extends Node3D
@onready var office: Node3D = $Office
@onready var demon_world: Node3D = $DemonWorld

func _ready() -> void:
	Globals.active_object_scene = office
