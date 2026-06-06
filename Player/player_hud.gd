extends Control
@onready var pickup_ray_cast: RayCast3D = $"../neck/camera/PickupRayCast"
@onready var e: TextureRect = $E

var item_picked_up : BasicItem

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if pickup_ray_cast.collide_with_bodies :
		if pickup_ray_cast.get_collider() :
			if pickup_ray_cast.get_collider() is BasicItem:
				if Input.is_action_just_pressed("Interract") && item_picked_up == null :
					item_picked_up = pickup_ray_cast.get_collider()
					item_picked_up.get_parent().remove_child(item_picked_up)
					item_picked_up.texture_in_ui
				e.visible = true
			else :
				e.visible = false
		else :
				e.visible = false
