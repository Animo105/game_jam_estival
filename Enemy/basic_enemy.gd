extends RigidBody3D
class_name BasicEnemy

const PATH_REFRESH_RATE : int = 3

@export var max_health : int = 10

@export var speed : float = 1.0
@export var stop_distance : float = 1

@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D
var player : Node3D

var health : int = 0
enum States {CHASSING, HIT, DEAD, COOLDOWN}
var state : States = States.CHASSING

var _frame_count : int = 0

var _timer : Timer = Timer.new()

func _ready() -> void:
	add_child(_timer)
	health = max_health

func hit(force : Vector3, damage : int):
	state = States.HIT
	linear_velocity = force
	health -= damage
	if health < 0:
		death()
	print("health"+str(health))

func death():
	queue_free()
	SignalBus.enemy_death.emit()

func _physics_process(_delta):
	if state == States.CHASSING:
		naviguate()
	elif state == States.HIT:
		hit_recoil()

func put_on_cooldown(time_s : float) -> void:
	state = States.COOLDOWN
	_timer.start(time_s)
	await _timer.timeout
	state = States.CHASSING

func hit_recoil():
	if linear_velocity.length() < 0.5:
		state = States.CHASSING

func naviguate():
	if not player:
		if Globals.player:
			player = Globals.player
		else:
			push_error("No player for enemies")
			return
	# 1. refresh la position tout les X frames
	_frame_count += 1
	if _frame_count >= PATH_REFRESH_RATE:
		nav_agent.target_position = player.global_transform.origin - (player.global_transform.origin - global_transform.origin).normalized() * stop_distance
		_frame_count = 0
	# 2. Vérifier si l'agent a atteint sa cible
	if nav_agent.is_navigation_finished():
		return
	# 3. Calculer la direction vers le prochain point du chemin
	var current_position = global_transform.origin
	var next_path_position = nav_agent.get_next_path_position()
	# 4. Calculer et appliquer la vélocité et déplacer l'ennemi
	linear_velocity = (next_path_position - current_position).normalized() * speed
	# Optionnel : Faire pivoter l'ennemi vers sa direction de marche
	if linear_velocity.length() > 0.1:
		var look_target = Vector3(player.global_position.x, global_transform.origin.y, player.global_position.z)
		look_at(look_target, Vector3.UP)
