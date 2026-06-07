extends Control
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var fire: TextureRect = $Fire
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fire.hide()
	SignalBus.player_life_changing.connect(on_life_changed)
	progress_bar.max_value = Player.STARTING_LIFE
	progress_bar.value = 5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_life_changed(new_amount :int) -> void :
	fire.show()
	timer.start()
	progress_bar.value = new_amount
	


func _on_timer_timeout() -> void:
	fire.hide()
