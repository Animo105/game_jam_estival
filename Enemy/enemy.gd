extends RigidBody3D

@export var speed : float = 1.0
@export var player_path : NodePath
@export var dist_to_player : float = 1.4

@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D
var player : Node3D

func _ready():
	if player_path:
		player = get_node(player_path)

func _physics_process(_delta):
	if not player:
		print('no_player')
		return
		
	# 1. Donner la position du joueur à l'agent de navigation
	nav_agent.target_position = player.global_transform.origin
	# 2. Vérifier si l'agent a atteint sa cible
	if nav_agent.is_navigation_finished():
		print('finish')
		return
		
	# 3. Calculer la direction vers le prochain point du chemin
	var current_position = global_transform.origin
	var next_path_position = nav_agent.get_next_path_position()
	print(current_position)
	print(next_path_position)
	# Calcul du vecteur de direction (en ignorant l'axe Y pour éviter que l'ennemi ne penche)
	var new_velocity = (next_path_position - current_position).normalized() * speed
	
	# 4. Appliquer la vélocité et déplacer l'ennemi
	linear_velocity = new_velocity
	
	# Optionnel : Faire pivoter l'ennemi vers sa direction de marche
	if linear_velocity.length() > 0.1:
		var look_target = Vector3(next_path_position.x, global_transform.origin.y, next_path_position.z)
		look_at(look_target, Vector3.UP)
