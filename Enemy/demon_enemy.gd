extends BasicEnemy

@onready var sprite_3d: Sprite3D = $Sprite3D

var time : float = 0
const SECOND_PER_FRAME : float = 0.1

func _process(delta: float) -> void:
	if state != States.CHASSING: return
	time += delta
	if time >= SECOND_PER_FRAME:
		time -= SECOND_PER_FRAME
		sprite_3d.frame = (sprite_3d.frame+1) % 4

func _on_area_3d_body_entered(body: Node3D) -> void:
	if state != States.CHASSING: return
	if body is Player:
		Globals.health -= 1
		var direction : Vector3 = (body.global_position - global_position).normalized()
		direction *= 40
		direction.y = 2
		body.linear_velocity += direction
		print("playerHP : " + str(Globals.health))
		put_on_cooldown(2)
