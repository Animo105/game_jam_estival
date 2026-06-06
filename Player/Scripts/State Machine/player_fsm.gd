extends Node
class_name PlayerFSM
signal on_state_change(String)

var states : Dictionary[String, PlayerState] = {}
var _current_state : PlayerState
var _current_state_key : String


func _ready() -> void:
	PlayerState.player = get_parent()
	for child in get_children():
		if child is PlayerState:
			child.fsm = self
			states[child.name.to_lower()] = child
			
		else:
			child.queue_free()
			push_warning("State machine contains a none state object")
	if states.is_empty():
		queue_free()
	else:
		change_state(states.keys()[0])

func physics_update(delta:float)->void:
	_current_state.physics_update(delta)

func update(delta:float)->void:
	_current_state.update(delta)

func change_state(state_name : String)->void:
	if states.has(state_name):
		if _current_state_key == state_name:
			return
		if _current_state:
			_current_state.exit(state_name)
		_current_state = states[state_name]
		on_state_change.emit(state_name)
		_current_state.enter(_current_state_key)
		_current_state_key = state_name
