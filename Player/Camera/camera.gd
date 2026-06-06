extends Camera3D

@onready var pickup_ray_cast: RayCast3D = $PickupRayCast
@onready var hands: HudHands = $CanvasLayer/HUD/Hands


var item_picked_up : BasicItem

func _ready() -> void:
	hands.default()

func _physics_process(_delta: float) -> void:
	check_for_pickup()
	check_for_item_action()

func check_for_pickup():
	if item_picked_up: return
	if pickup_ray_cast.is_colliding() && pickup_ray_cast.get_collider() is BasicItem:
		hands.pickup()
		if Input.is_action_just_pressed("left_click"):
			pickup(pickup_ray_cast.get_collider())
	else:
		hands.default()

func pickup(basic_item : BasicItem):
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
	else:
		print("ho, ho... problems!")

func use_item():
	if not item_picked_up: return
	item_picked_up.use(global_position, -global_basis.z)

func throw_item():
	if not item_picked_up: return
	if item_picked_up.throw(global_position, -global_basis.z):
		item_picked_up = null
	else:
		print("ho, ho... problems!")
