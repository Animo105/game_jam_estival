extends Node


const REGEN_RATE : int = 3
const OFFICE_SWAP_MAX_TIME : int = 5
const DAEMON_SWAP_MIN_TIME : int = 10

var do_swap_timer : bool = false
var can_swap : bool = true
var life_gain_timer : Timer = Timer.new()
var office_swap_timer : Timer = Timer.new()
var daemon_swap_timer : Timer = Timer.new()

func _ready() -> void:
	life_gain_timer.wait_time = REGEN_RATE
	life_gain_timer.autostart = false
	office_swap_timer.wait_time = OFFICE_SWAP_MAX_TIME
	office_swap_timer.autostart = false
	daemon_swap_timer.wait_time = DAEMON_SWAP_MIN_TIME



func swap():
	pass
