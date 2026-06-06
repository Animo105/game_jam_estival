extends Camera3D

@onready var pickup_ray_cast: RayCast3D = $PickupRayCast
@onready var item_prompts: Control = $CanvasLayer/HUD/ItemPrompts
@onready var hands: TextureRect = $CanvasLayer/HUD/Hands

var item_picked_up : BasicItem

@onready var DEFAULT_HANDS_TEXTURE : Texture2D = load("uid://qqvo8x54ixe5")
const PICKUP_HAND_TEXTURE = preload("uid://ygxynmnd8fne")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item_prompts.visible = true
	hands.texture = DEFAULT_HANDS_TEXTURE

func _physics_process(_delta: float) -> void:
	check_for_pickup()

func check_for_pickup():
	if item_picked_up: return
	if pickup_ray_cast.is_colliding() && pickup_ray_cast.get_collider() is BasicItem:
		hands.texture = PICKUP_HAND_TEXTURE
		if Input.is_action_just_pressed("left_click"):
			pickup(pickup_ray_cast.get_collider())
	else:
		hands.texture = DEFAULT_HANDS_TEXTURE

func pickup(basic_item : BasicItem):
	item_picked_up = basic_item
	basic_item.get_parent().remove_child(basic_item)
	if basic_item.texture_in_ui:
		hands.texture = basic_item.texture_in_ui
	item_prompts.visible = false
	SignalBus.item_picked_up.emit()

func drop_item():
	pass
