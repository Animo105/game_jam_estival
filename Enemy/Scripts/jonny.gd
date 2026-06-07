extends BasicEnemy

func _physics_process(_delta):
	if state == States.CHASSING:
		naviguate()
	elif state == States.HIT:
		hit_recoil()
