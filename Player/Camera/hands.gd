extends TextureRect
class_name HudHands


const IDLE = preload("uid://dysrq1ahucm43")
const GRAB_HANDS = preload("uid://t82slqdsxqqc")
const FIST = preload("uid://qqvo8x54ixe5")

signal finished_animation

var pickup_texture : Texture = null

var animation_frames : Array[Texture] = []
var animation_index : int = 0
var tween : Tween
var animation_playing : bool = false
var last_frame : int = -1

func _ready() -> void:
	Globals.hud_hands = self

func _process(_delta: float) -> void:
	if animation_playing:
		if animation_index != last_frame:
			last_frame = animation_index
			texture = animation_frames[animation_index]

func default():
	if animation_playing: return
	texture = IDLE

func pickup():
	if animation_playing: return
	texture = GRAB_HANDS

func fists():
	if animation_playing: return
	texture = FIST

func set_item_texture(item_texture : Texture):
	if animation_playing:
		animation_playing = false
		tween.kill()
		finished_animation.emit()
	pickup_texture = item_texture
	texture = item_texture

func play_once_animation(frames : Array[Texture], time : float = 1) -> void:
	if tween:
		tween.kill()
	animation_frames = frames
	animation_index = 0
	last_frame = -1
	tween = create_tween()
	animation_playing = true
	tween.tween_property(self, "animation_index", frames.size()-1, time)
	await tween.finished
	animation_playing = false
	finished_animation.emit()
	if pickup_texture:
		texture = pickup_texture
	
