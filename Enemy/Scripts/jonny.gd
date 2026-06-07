extends BasicEnemy

const MAXIMAL_JONNY_RANGE : int = 5

@onready var sexy_mouth: Marker3D = $sexy_mouth
@onready var fire_cooldown: Timer = $fire_cooldown

var can_spit_fire : bool = true
var recoil_time : float = 0

func _physics_process(_delta):
	if state == States.CHASSING:
		naviguate()
		lauch_fire_ball()
	elif state == States.HIT:
		hit_recoil()

func recoil(delta : float):
	recoil_time += delta
	if recoil_time >= 1.5:
		recoil_time = 0
		state = States.CHASSING

func hit_recoil():
	if linear_velocity.length() < 0.5:
		state = States.CHASSING

func lauch_fire_ball():
	if not player: return
	if not can_spit_fire: return
	var dist_to_player = global_position.distance_to(player.global_position)
	if dist_to_player < MAXIMAL_JONNY_RANGE:
		var fire_ball = FireBall.generate()
		var dir = global_position.direction_to(player.global_position)
		Globals.active_object_scene.add_child(fire_ball)
		fire_ball.global_position = sexy_mouth.global_position
		fire_ball.lauch(dir, 5, 1)
		can_spit_fire = false
		fire_cooldown.start()


func _on_fire_cooldown_timeout() -> void:
	can_spit_fire = true
