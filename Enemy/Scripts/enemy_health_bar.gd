extends ProgressBar
class_name EnemyHealthBar

@export var enemy : BasicEnemy
@export var screen_position : Marker3D
@export var width : float = 100.0

var camera : Camera3D
var visible_on_screen : VisibleOnScreenEnabler3D = VisibleOnScreenEnabler3D.new()

func _ready() -> void:
	if not enemy or not screen_position:
		queue_free()
		return
	visible_on_screen.enable_node_path = self.get_path()
	visible_on_screen.aabb = AABB(Vector3.ZERO, Vector3(0.1,1, 0.1))
	enemy.add_child.call_deferred(visible_on_screen)
	show_percentage = false
	camera = get_viewport().get_camera_3d()
	max_value = enemy.max_health
	value = enemy.health
	visible = not max_value == value
	enemy.damaged.connect(update)
	custom_minimum_size.x = width
	SwapManager.enter_office.connect(enter_office)

func enter_office():
	visible = false

func _process(_delta: float) -> void:
	if not camera: return
	if camera.global_transform.origin.distance_to(enemy.global_transform.origin) > 5:
		visible = false
		return
	visible = true
	var screen_pos = camera.unproject_position(screen_position.global_position)
	global_position = screen_pos
	global_position += Vector2(-get_rect().size.x / 2, 0)

func update():
	value = enemy.health
