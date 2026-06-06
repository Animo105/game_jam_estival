@abstract extends Node
class_name PlayerState

static var player : Player
var fsm : PlayerFSM

func enter(_previous_state : String)-> void:
	pass

func exit(_next_state : String)-> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func update(_delta : float) -> void:
	pass
