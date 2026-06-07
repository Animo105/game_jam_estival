extends Node

enum Sound {
	STEP,
	FIRE,
	DASH,
	CARD,
	HIT,
	DEAD,
}

const PLAYER_POOL_SIZE: int = 32

const SOUND_PITCH_VARIATION := {
	Sound.STEP: 0.1,
	Sound.FIRE: 0.1,
	Sound.DASH: 0.2,
	Sound.CARD: 0.0,
	Sound.HIT: 0.1,
	Sound.DEAD: 0.1
}

var sounds := {
	Sound.STEP: preload("res://Assets/Sounds/Step1.wav") as AudioStream,
	Sound.FIRE: preload("res://Assets/Sounds/Fire.ogg") as AudioStream,
	Sound.DASH: preload("res://Assets/Sounds/dash.ogg") as AudioStream,
	Sound.CARD: preload("res://Assets/Sounds/card flash.ogg") as AudioStream,
	Sound.HIT: preload("res://Assets/Sounds/hit.ogg") as AudioStream,
	Sound.DEAD: preload("res://Assets/Sounds/dead.ogg") as AudioStream,
	
}

var players: Array[AudioStreamPlayer] = []

func _ready() -> void:
	for i: int in PLAYER_POOL_SIZE:
		var player: AudioStreamPlayer = AudioStreamPlayer.new()
		add_child(player)
		players.append(player)

func play(sound: Sound, volume_db: float = 0.0) -> void:
	var player: AudioStreamPlayer = _get_available_player()

	player.stream = sounds[sound] as AudioStream
	player.volume_db = volume_db

	var variation: float = SOUND_PITCH_VARIATION.get(sound, 0.05)

	player.pitch_scale = randf_range(
		1.0 - variation,
		1.0 + variation
	)

	player.play()

func _get_available_player() -> AudioStreamPlayer:
	for player: AudioStreamPlayer in players:
		if not player.playing:
			return player

	players[0].stop()
	return players[0]
