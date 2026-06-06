extends RigidBody3D
class_name BasicEnemy

@export var speed : float = 1.0
var dist_to_player : float = 0

@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D
var player : Node3D

enum States {CHASSING, HIT, DEAD}
var state : States = States.CHASSING 

func hit(force : Vector3, damage : float):
	state = States.HIT
	linear_velocity = force

func _physics_process(_delta):
	if state == States.CHASSING:
		naviguate()
	elif state == States.HIT:
		hit_recoil()

func hit_recoil():
	if linear_velocity.length() < 0.5:
		state = States.CHASSING

func naviguate():
	if not player:
		if Globals.player:
			player = Globals.player
		else:
			return
	# 1. Donner la position du joueur à l'agent de navigation
	nav_agent.target_position = player.global_transform.origin
	# 2. Vérifier si l'agent a atteint sa cible
	if nav_agent.is_navigation_finished():
		return
	# 3. Calculer la direction vers le prochain point du chemin
	var current_position = global_transform.origin
	var next_path_position = nav_agent.get_next_path_position()
	# Calcul du vecteur de direction (en ignorant l'axe Y pour éviter que l'ennemi ne penche)
	var new_velocity = (next_path_position - current_position).normalized() * speed
	# 4. Appliquer la vélocité et déplacer l'ennemi
	linear_velocity = new_velocity
	# Optionnel : Faire pivoter l'ennemi vers sa direction de marche
	if linear_velocity.length() > 0.1:
		var look_target = Vector3(next_path_position.x, global_transform.origin.y, next_path_position.z)
		look_at(look_target, Vector3.UP)
