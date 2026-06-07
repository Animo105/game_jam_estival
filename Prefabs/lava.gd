extends Node3D
@onready var mesh: MeshInstance3D = $Mesh


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var material := mesh.get_active_material(0) as StandardMaterial3D
	if material:
		material.uv1_offset += Vector3(delta * 0.02, delta * 0.02, delta * 0.02)


func _on_area_3d_body_entered(body: Node3D) -> void:
	var player = body as Player
	
	if player:
		player.linear_velocity.y += 15.0
		player.health -= 1
