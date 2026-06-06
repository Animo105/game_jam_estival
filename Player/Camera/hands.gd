extends TextureRect
class_name HudHands

@onready var DEFAULT_HANDS_TEXTURE : Texture2D = load("uid://qqvo8x54ixe5")
@onready var PICKUP_HAND_TEXTURE = load("uid://ygxynmnd8fne")

var pickup_texture : Texture = null

func _ready() -> void:
	Globals.hud_hands = self

func default():
	texture = DEFAULT_HANDS_TEXTURE

func pickup():
	texture = PICKUP_HAND_TEXTURE

func set_item_texture(item_texture : Texture):
	texture = item_texture
	pickup_texture = item_texture
