extends BasicEnemy
@onready var stun: Timer = $Stun


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		Globals.health -= 1
		var direction : Vector3 = (body.global_position - global_position).normalized()
		direction *= 40
		direction.y = 2
		body.linear_velocity += direction
		print("playerHP : " + str(Globals.health))
		state = States.HIT
		stun.start()
