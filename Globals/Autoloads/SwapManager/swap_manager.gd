extends Node

signal enter_office
signal enter_demon_world

const REGEN_RATE : int = 6
const OFFICE_SWAP_MAX_TIME : int = 3
const DEMON_SWAP_MIN_TIME : int = 5

@onready var timer: Control = $Timer
@onready var progress_bar: ProgressBar = $Timer/ProgressBar

var do_swap_timer : bool = false
var is_in_office : bool = false
var can_swap : bool = true
var life_gain_timer : Timer = Timer.new()
var office_swap_timer : Timer = Timer.new()
var demon_swap_timer : Timer = Timer.new()

var animation_to_office : Array[Texture] = [
	load("res://Assets/hands/tower_flip1.png"),
	load("res://Assets/hands/tower_flip2.png"),
	load("res://Assets/hands/tower_flip3.png"),
	load("res://Assets/hands/tower_up.png"),
	load("res://Assets/hands/tower_up.png"),
	load("res://Assets/hands/tower_up.png"),
]
var animation_to_demon : Array[Texture] = [
	load("res://Assets/hands/tower_flip3.png"),
	load("res://Assets/hands/tower_flip2.png"),
	load("res://Assets/hands/tower_flip1.png"),
	load("res://Assets/hands/tower_inverse.png"),
	load("res://Assets/hands/tower_inverse.png"),
	load("res://Assets/hands/tower_inverse.png"),
]

func _ready() -> void:
	life_gain_timer.wait_time = REGEN_RATE
	life_gain_timer.autostart = false
	life_gain_timer.one_shot = true
	office_swap_timer.wait_time = OFFICE_SWAP_MAX_TIME
	office_swap_timer.autostart = false
	office_swap_timer.one_shot = true
	demon_swap_timer.wait_time = DEMON_SWAP_MIN_TIME
	demon_swap_timer.autostart = false
	demon_swap_timer.one_shot = true
	SignalBus.player_life_changing.connect(player_life_changed)
	SignalBus.player_death.connect(player_death)
	life_gain_timer.timeout.connect(life_gain_timer_timeout)
	office_swap_timer.timeout.connect(office_timer_timeout)
	demon_swap_timer.timeout.connect(demon_timer_timeout)
	add_child(life_gain_timer)
	add_child(office_swap_timer)
	add_child(demon_swap_timer)
	set_swap_mode(false)
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

func player_life_changed(new_amount : int)-> void:
	life_gain_timer.start()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("swap") && can_swap:
		swap()

func set_swap_mode(enable : bool):
	do_swap_timer = enable
	can_swap = true
	if not enable:
		timer.visible = false
		office_swap_timer.stop()
		demon_swap_timer.stop()
	
	else:
		timer.visible = true
		office_swap_timer.start()

func player_death():
	swap_to_office.call_deferred()

func swap():
	if is_in_office:
		# change to demon
		if not office_swap_timer.is_stopped():
			office_swap_timer.stop()
		Globals.hud_hands.play_once_animation(animation_to_demon, 0.4)
		await Globals.hud_hands.finished_animation
		swap_to_daemon()
	else:
		#change to office
		if not demon_swap_timer.is_stopped():
			demon_swap_timer.stop()
		Globals.hud_hands.play_once_animation(animation_to_office, 0.4)
		await Globals.hud_hands.finished_animation
		swap_to_office()
		

func life_gain_timer_timeout():
	if Globals.player.health < Player.STARTING_LIFE:
		Globals.player.health+=1
	if Globals.player.health < Player.STARTING_LIFE:
		life_gain_timer.start()

func office_timer_timeout():
	swap()

func demon_timer_timeout():
	can_swap = true

func lock_in_office():
	demon_swap_timer.stop()
	office_swap_timer.stop()
	can_swap = false
	timer.visible = false
	Globals.hud_hands.play_once_animation(animation_to_office, 0.4)
	await Globals.hud_hands.finished_animation
	is_in_office = true
	enter_office.emit()

func restart_timer():
	set_swap_mode(true)
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
