extends Node

@export var max_players : int = 8

var plastic_sounds : Array[AudioStream] = [load("res://Assets/Sounds/Plastic1.wav"), load("res://Assets/Sounds/Plastic2.wav"),load("res://Assets/Sounds/Plastic3.wav"), load("res://Assets/Sounds/Plastic4.wav")]
var walking_sound : Array[AudioStream] = [load('res://Assets/Sounds/Step1.wav'), load("res://Assets/Sounds/Step2.wav"), load("res://Assets/Sounds/Step3.wav"), load("res://Assets/Sounds/Step4.wav")]
var available_players : Array[AudioStreamPlayer] = []

func _ready() -> void:
	for i in range(max_players):
		var p = AudioStreamPlayer.new()
		add_child(p)
		available_players.append(p)
		p.finished.connect(_on_stream_player_finished.bind(p))

# La fonction principale à appeler partout dans le projet
func _play_step_sound() -> void:
	var step_sound = walking_sound.pick_random()
	play_sound(step_sound, 2, randf_range(0.95, 1.05))

func _play_plastic_sound() -> void:
	var plastic_sound = plastic_sounds.pick_random()
	play_sound(plastic_sound, 10,1, 0.4)

func play_sound(stream: AudioStream, volume_db: float = 0.0, pitch_scale: float = 1.0, from_position: float = 0.0) -> void:
	if stream == null:
		return
		
	# On cherche un lecteur de libre
	if not available_players.is_empty():
		var p = available_players.pop_back()
		p.stream = stream
		p.volume_db = volume_db
		p.pitch_scale = pitch_scale
		p.play(from_position)
	else:
		print("Too much sounds !")

func _on_stream_player_finished(player: AudioStreamPlayer) -> void:
	available_players.append(player)
