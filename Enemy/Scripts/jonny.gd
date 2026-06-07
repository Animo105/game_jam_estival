extends BasicEnemy

func _physics_process(_delta):
	if state == States.CHASSING:
		naviguate()
	elif state == States.HIT:
		hit_recoil()

func handle_altitude():
	if global_position.y < 1:
		print("up")
		apply_force(Vector3.UP * 5)
