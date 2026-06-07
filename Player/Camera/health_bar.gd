extends Control
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var regen_bar: ProgressBar = $RegenBar

@onready var fire: TextureRect = $Fire
@onready var timer: Timer = $Timer

var regen_timer : Timer = null
var regen_rate := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	regen_bar.value = 0
	fire.hide()
	SignalBus.player_life_changing.connect(on_life_changed)
	SignalBus.start_player_health_gain.connect(on_start_health_gain)
	progress_bar.max_value = Player.STARTING_LIFE
	progress_bar.value = 5
	SwapManager.life_gain_timer.timeout.connect(health_timeout)


func on_start_health_gain(REGEN_RATE :int, life_gain_timer :Timer) -> void :
	
	regen_rate = REGEN_RATE
	regen_timer = life_gain_timer
	regen_bar.value = 0
	regen_bar.max_value = REGEN_RATE

func health_timeout() -> void :
	progress_bar.value = Globals.player.health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Globals.player.health >= Player.STARTING_LIFE :
		regen_bar.value = 0
		return
	
	if regen_timer:
		regen_bar.value = regen_rate - regen_timer.time_left

func on_life_changed(new_amount :int, decreasing :bool) -> void :
	progress_bar.value = new_amount
	if !decreasing :
		return
	
	fire.show()
	timer.start()
	


func _on_timer_timeout() -> void:
	fire.hide()
