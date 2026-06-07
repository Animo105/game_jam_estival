extends BasicItem
class_name FoodItem

@export var life_gain : int = 1

func pickup() -> bool:
	
	if Globals.player.health < Player.STARTING_LIFE:
		Globals.player.health += 1
		queue_free()
	return false
