extends TextureRect
class_name HudHands

@onready var DEFAULT_HANDS_TEXTURE : Texture2D = load("uid://qqvo8x54ixe5")
@onready var PICKUP_HAND_TEXTURE = load("uid://ygxynmnd8fne")

func default():
	texture = DEFAULT_HANDS_TEXTURE

func pickup():
	texture = PICKUP_HAND_TEXTURE

func set_item_texture(item_texture : Texture):
	texture = item_texture
