extends Node

signal enter_office
signal enter_demon_world

const REGEN_RATE : int = 3
const OFFICE_SWAP_MAX_TIME : int = 5
const DEMON_SWAP_MIN_TIME : int = 10

@onready var progress_bar: ProgressBar = $CanvasLayer/HBoxContainer/ProgressBar

var do_swap_timer : bool = false
var is_in_office : bool = false
var can_swap : bool = true
var life_gain_timer : Timer = Timer.new()
var office_swap_timer : Timer = Timer.new()
var demon_swap_timer : Timer = Timer.new()

func _ready() -> void:
	set_swap_mode(false)
	life_gain_timer.wait_time = REGEN_RATE
	life_gain_timer.autostart = false
	life_gain_timer.one_shot = true
	office_swap_timer.wait_time = OFFICE_SWAP_MAX_TIME
	office_swap_timer.autostart = false
	office_swap_timer.one_shot = true
	demon_swap_timer.wait_time = DEMON_SWAP_MIN_TIME
	demon_swap_timer.autostart = false
	demon_swap_timer.one_shot = true
	life_gain_timer.timeout.connect(life_gain_timer_timeout)
	office_swap_timer.timeout.connect(office_timer_timeout)
	demon_swap_timer.timeout.connect(demon_timer_timeout)
	add_child(life_gain_timer)
	add_child(office_swap_timer)
	add_child(demon_swap_timer)
	swap_to_office()

func _process(_delta: float) -> void:
	if is_in_office:
		if not office_swap_timer.is_stopped():
			progress_bar.value = OFFICE_SWAP_MAX_TIME - office_swap_timer.time_left
		else:
			progress_bar.value = OFFICE_SWAP_MAX_TIME
	else:
		if not demon_swap_timer.is_stopped():
			progress_bar.value = DEMON_SWAP_MIN_TIME - demon_swap_timer.time_left
		else:
			progress_bar.value = DEMON_SWAP_MIN_TIME

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("swap") && can_swap:
		swap()

func set_swap_mode(enable : bool):
	do_swap_timer = enable
	can_swap = true
	if not enable:
		office_swap_timer.stop()
		demon_swap_timer.stop()
		progress_bar.visible = false
	else:
		office_swap_timer.start()

func swap():
	if is_in_office:
		# change to demon
		if not office_swap_timer.is_stopped():
			office_swap_timer.stop()
		swap_to_daemon()
	else:
		#change to office
		if not demon_swap_timer.is_stopped():
			demon_swap_timer.stop()
		swap_to_office()
		

func life_gain_timer_timeout():
	pass

func office_timer_timeout():
	swap()

func demon_timer_timeout():
	can_swap = true

func lock_in_office():
	demon_swap_timer.stop()
	office_swap_timer.stop()
	can_swap = false
	progress_bar.visible = false
	is_in_office = true
	enter_office.emit()

func restart_timer():
	progress_bar.visible = true
	do_swap_timer = true
	swap_to_office()
	

func swap_to_office():
	progress_bar.value = 0
	progress_bar.max_value = OFFICE_SWAP_MAX_TIME
	can_swap = true
	is_in_office = true
	enter_office.emit()
	if do_swap_timer:
		office_swap_timer.start()

func swap_to_daemon():
	progress_bar.value = 0
	progress_bar.max_value = DEMON_SWAP_MIN_TIME
	if do_swap_timer: can_swap = false
	is_in_office = false
	enter_demon_world.emit()
	if do_swap_timer:
		demon_swap_timer.start()
