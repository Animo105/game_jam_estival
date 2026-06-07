extends CharacterBody3D
class_name FireBall

const FIRE_BALL = preload("uid://blhku3fh01ga0")

static func generate() -> FireBall:
	return FIRE_BALL.instantiate()

var dir : Vector3 = Vector3.ZERO
var spd : float = 0
var dmg : int = 0

func lauch(direction : Vector3, speed : float, damage : int) -> void:
	dir = direction
	spd = speed
	dmg = damage

func _physics_process(delta: float) -> void:
	var collision : = move_and_collide(dir * spd * delta)
	if collision:
		var collider = collision.get_collider()
		if collider is Player:
			collider.health -= dmg
			queue_free()
		else:
			queue_free()
