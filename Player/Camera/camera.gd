extends Camera3D

@onready var pickup_ray_cast: RayCast3D = $PickupRayCast
@onready var throw_hand_ray_cast: RayCast3D = $ThrowHandRayCast
@onready var hands: HudHands = $CanvasLayer/HUD/Hands

var throw_hand_animation : Array[Texture] = [
	load("res://Assets/hands/punch1.png"),
	load("res://Assets/hands/Fist.png"),
	load("res://Assets/hands/punch2.png"),
	load("res://Assets/hands/Fist.png")
]
var item_picked_up : BasicItem
var is_throwing_hands : bool = false

func _ready() -> void:
	SignalBus.player_death.connect(_on_player_death)
	hands.default()

func _physics_process(_delta: float) -> void:
	check_for_item_action()
	check_for_hand_action()

func _on_player_death():
	item_picked_up = null

func check_for_hand_action():
	if item_picked_up: return
	if pickup_ray_cast.is_colliding() && pickup_ray_cast.get_collider() is BasicItem:
		hands.pickup()
		if Input.is_action_just_pressed("left_click"):
			pickup(pickup_ray_cast.get_collider())
	elif throw_hand_ray_cast.is_colliding() && throw_hand_ray_cast.get_collider() is BasicEnemy:
		hands.fists()
		if Input.is_action_just_pressed("left_click") && not is_throwing_hands:
			is_throwing_hands = true
			hands.pickup_texture = null
			throw_hand_ray_cast.get_collider().hit(Vector3.ZERO, 1)
			hands.play_once_animation(throw_hand_animation, 0.5)
			await hands.finished_animation
			is_throwing_hands = false
	else:
		hands.default()

func pickup(basic_item : BasicItem):
	if basic_item.pickup():
		item_picked_up = basic_item
		basic_item.get_parent().remove_child(basic_item)
		if basic_item.texture_in_ui:
			hands.set_item_texture(basic_item.texture_in_ui)
		SignalBus.item_picked_up.emit()

func check_for_item_action():
	if not item_picked_up: return
	if Input.is_action_just_pressed("drop"):
		drop_item()
	elif Input.is_action_just_pressed("right_click"):
		throw_item()
	elif Input.is_action_just_pressed("left_click"):
		use_item()

func drop_item():
	if not item_picked_up: return
	if item_picked_up.drop_at(global_position, -global_basis.z):
		item_picked_up = null
		hands.pickup_texture = null

func use_item():
	if not item_picked_up: return
	item_picked_up.use(global_position, -global_basis.z)
	if item_picked_up.is_queued_for_deletion():
		item_picked_up = null
		print("queued for deletion")
		hands.pickup_texture = null

func throw_item():
	if not item_picked_up: return
	if item_picked_up.throw(global_position, -global_basis.z):
		item_picked_up = null
		hands.pickup_texture = null
