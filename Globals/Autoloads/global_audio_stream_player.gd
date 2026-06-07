extends AudioStreamPlayer

@onready var war_intro = $WarIntro
@onready var war_loop = $WarLoop
@onready var elevator = $Elevator

var war_bus := AudioServer.get_bus_index("War")
var elevator_bus := AudioServer.get_bus_index("Elevator")

func _ready():
	# start everything silent except intro
	AudioServer.set_bus_volume_db(war_bus, 0)
	AudioServer.set_bus_volume_db(elevator_bus, -80)

	war_loop.volume_db = -80
	elevator.volume_db = 0

	war_intro.finished.connect(_on_intro_finished)
	war_intro.play()


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
		-30.0,
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
		-30.0,
		duration
	)
