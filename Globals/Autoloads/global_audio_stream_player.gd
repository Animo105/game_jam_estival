extends Node

@onready var war_intro = AudioStreamPlayer.new()
@onready var war_loop = AudioStreamPlayer.new()
@onready var elevator = AudioStreamPlayer.new()

var war_bus := AudioServer.get_bus_index("War")
var elevator_bus := AudioServer.get_bus_index("Elevator")

func _ready():
	# assign streams
	war_intro.stream = load("res://Globals/Autoloads/Music Stuff/Musics/Hell/Intro/war_intro.ogg")
	war_loop.stream = load("res://Globals/Autoloads/Music Stuff/Musics/Hell/Loop/war_loop.ogg")
	elevator.stream = load("res://Globals/Autoloads/Music Stuff/Musics/elevator/ElevatorMusic.ogg")

	# assign buses (CRITICAL)
	war_intro.bus = "Intro"
	war_loop.bus = "War"
	elevator.bus = "Elevator"

	# add to tree BEFORE play
	add_child(war_intro)
	add_child(war_loop)
	add_child(elevator)

	# start states
	AudioServer.set_bus_volume_db(war_bus, 0)
	AudioServer.set_bus_volume_db(elevator_bus, -80)

	war_intro.finished.connect(_on_intro_finished)
	war_intro.play()
	elevator.play() # MUST be playing for fade to work



func _on_intro_finished():
	war_loop.play()


func enter_elevator(duration := 1.0):
	var tween = create_tween()

	tween.parallel().tween_method(
		func(v): AudioServer.set_bus_volume_db(war_bus, v),
		0.0,
		-25.0,
		duration
	)

	tween.parallel().tween_method(
		func(v): AudioServer.set_bus_volume_db(elevator_bus, v),
		-80.0,
		0.0,
		duration
	)


func exit_elevator(duration := 1.0):
	var tween = create_tween()

	tween.parallel().tween_method(
		func(v): AudioServer.set_bus_volume_db(war_bus, v),
		-25.0,
		0.0,
		duration
	)

	tween.parallel().tween_method(
		func(v): AudioServer.set_bus_volume_db(elevator_bus, v),
		0.0,
		-80.0,
		duration
	)
