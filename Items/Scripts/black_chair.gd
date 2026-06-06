extends CombatItem

var can_attack : bool = true
@export var animation : Array[Texture]

func use(camera_coords : Vector3, forward_direction : Vector3):
	if not can_attack: return
	can_attack = false
	super.use(camera_coords, forward_direction)
	Globals.hud_hands.play_once_animation(animation, 0.3)
	await Globals.hud_hands.finished_animation
	can_attack = true
	
