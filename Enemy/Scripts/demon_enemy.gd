extends BasicEnemy

@onready var sprite_3d: Sprite3D = $Sprite3D
@onready var range_area: Area3D = $RangeArea

var time : float = 0
const SECOND_PER_FRAME : float = 0.1

func _process(delta: float) -> void:
	if state != States.CHASSING: return
	time += delta
	if time >= SECOND_PER_FRAME:
		time -= SECOND_PER_FRAME
		sprite_3d.frame = (sprite_3d.frame+1) % 4

func _physics_process(_delta):
	if state == States.CHASSING:
		naviguate()
		check_for_player()
	elif state == States.HIT:
		hit_recoil()

func check_for_player():
	if state != States.CHASSING: return
	for body in range_area.get_overlapping_bodies():
		if body is Player:
			player.health -= 1
			var direction : Vector3 = (body.global_position - global_position).normalized()
			direction *= 40
			direction.y = 2
			body.linear_velocity += direction
			put_on_cooldown(2)
