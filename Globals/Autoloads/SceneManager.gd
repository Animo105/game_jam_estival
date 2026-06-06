## Handles scene transitions and ensures only one active scene at a time.
## 
## This manager is responsible for changing the current scene, optionally freeing the previous one,
## and preventing multiple transitions from happening simultaneously.
extends Node

## The current scene of the Tree. Same as [code]get_tree().current_scene[/code]
var current_scene : Node : get = _get_current_scene
## The previous scene that was not freed upon scene_change.
var previous_scene : Node

var _saved_nodes : Dictionary[String, Node]
var _pending_node_scene : Node = null
var _pending_free_current_scene : bool = true
var _scene_change_queued : bool = false

func _get_current_scene():
	return get_tree().current_scene

func _change_scene():
	var node = _pending_node_scene
	var free_current_scene = _pending_free_current_scene
	_pending_node_scene = null
	_pending_free_current_scene = true
	_scene_change_queued = false
	if not is_instance_valid(node) or node.is_queued_for_deletion() :
		push_error("Node was freed between the call and the change.")
		return
	if node.get_parent():
		node.get_parent().remove_child(node)
	var scene : Node = current_scene
	if is_instance_valid(scene) && not scene.is_queued_for_deletion():
		get_tree().root.remove_child(scene)
		if free_current_scene:
			scene.queue_free()
		else:
			previous_scene = scene
	get_tree().root.add_child(node)
	get_tree().current_scene = node

## Loads the given [param node] as the main scene.
## If [param free_current_scene] is false, the current scene will not be freed
## and will instead be stored in [member previous_scene].[br]
## 
## Returns [constant OK] on success, or [constant ERR_DOES_NOT_EXIST]
## if [param node] is null. If the [param node] has a parent, it will be detached
## before being set as the main scene.
func load_from_node(node : Node, free_current_scene : bool = true) -> Error:
	if not node:
		return Error.ERR_DOES_NOT_EXIST
	_pending_node_scene = node
	_pending_free_current_scene = free_current_scene
	if not _scene_change_queued:
		_change_scene.call_deferred()
		_scene_change_queued = true
	return Error.OK

## Instantiates the given [param packed_scene] and loads it as the main scene via [method load_from_node].
## If [param free_current_scene] is false, the current scene will not be freed
## and will instead be stored in [member previous_scene].[br]
##
## Returns [constant OK] on success, [constant ERR_DOES_NOT_EXIST]
## if [param packed_scene] is null, or [constant ERR_INVALID_PARAMETER]
## if the [param packed_scene] cannot be instantiated.
func load_from_packed_scene(packed_scene : PackedScene, free_current_scene : bool = true) -> Error:
	if not packed_scene:
		return Error.ERR_DOES_NOT_EXIST
	if not packed_scene.can_instantiate():
		return Error.ERR_INVALID_PARAMETER
	var node : Node = packed_scene.instantiate()
	return load_from_node(node, free_current_scene)

## Loads a scene from the given [param file_path], converts it into a PackedScene,
## and loads it as the main scene via [method load_from_packed_scene].
## If [param free_current_scene] is false, the current scene will not be freed
## and will instead be stored in [member previous_scene].[br]
##
## Returns [constant OK] on success, [constant ERR_FILE_BAD_PATH] if the file does not exist,
## or [constant ERR_INVALID_PARAMETER] if the loaded file is not a valid PackedScene.
func load_from_file(path : String, free_current_scene : bool = true) -> Error:
	if not FileAccess.file_exists(path):
		return Error.ERR_FILE_BAD_PATH
	var packed = load(path)
	if not packed is PackedScene:
		return Error.ERR_INVALID_PARAMETER
	return load_from_packed_scene(packed, free_current_scene)

## Loads a previously saved scene associated with the given [param key] and sets it as the main scene via [method load_from_node].
## This requires the scene to have been previously stored using [method save_current_scene_as].[br]
##
## Returns [constant OK] on success, or [constant ERR_DOES_NOT_EXIST] if the [param key] does not exist or is invalid.
func load_from_saved_key(key : String, free_current_scene : bool = true) -> Error:
	if not _saved_nodes.has(key) or not _saved_nodes[key]:
		return Error.ERR_DOES_NOT_EXIST
	return load_from_node(_saved_nodes[key], free_current_scene)

## Saves the [member current_scene] under the given [param key].
## The scene can later be restored using [method load_from_saved_key] provided it wasn't freed.
func save_current_scene_as(key : String) -> void:
	_saved_nodes[key] = current_scene

## Free the saved scene under the [param key] provided.
func free_saved_scene(key : String) -> void:
	if _saved_nodes.has(key):
		_saved_nodes[key].queue_free()
		_saved_nodes.erase(key)

## Free all the saved scene.
func free_all_saved_scene() -> void:
	for key in _saved_nodes.keys():
		if _saved_nodes[key]:
			_saved_nodes[key].queue_free()
		_saved_nodes.erase(key)

## Load the previous scene via [method load_from_node].
func load_previous_scene() -> Error:
	return load_from_node(previous_scene)

## Free the previous scene.
func free_previous_scene() -> void:
	if previous_scene:
		previous_scene.queue_free()
	previous_scene = null
