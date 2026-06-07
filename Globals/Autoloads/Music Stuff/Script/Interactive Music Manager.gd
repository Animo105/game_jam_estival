extends Node
var root_folder = "res://Globals/Autoloads/Music Stuff/Musics/"
var music_folder:DirAccess
@export var Toggle_Debug = true

var bus_dict: = {}
var players:Array[AudioStreamPlayer] = []

enum States {INTRO, LOOP, OUTRO}
var state = States.INTRO

func _ready() -> void:
	play("Hell")

func _process(_delta: float):
	gain_detector()
	return

func _on_player_finished():
	if state == States.INTRO:
		for player in players:
			player.stop()
		
		var to_empty = players.duplicate()
		for player in to_empty:
			player.queue_free()
		players.clear()
		var bus_amount = AudioServer.bus_count - 1
		print("there are ", bus_amount," busses")
		for i in range(bus_amount, 1, -1):
			AudioServer.remove_bus(i)
		bus_amount = AudioServer.bus_count - 1
		print("there are ", bus_amount," busses")
		bus_dict.clear()

		if Toggle_Debug == true:
			print("\nSWITCHING TO LOOP\n","\n──────────────────────────────────────────────────────────────────────────────────────────")

		dir_contents(music_folder.get_current_dir() + "/Loop/")
		state = States.LOOP
		return
	
	if state == States.LOOP:
		for player in players:
			player.play()
		return
	return

func play(music_name):
	music_folder = DirAccess.open(root_folder + music_name)
	if music_folder.dir_exists("Intro/"):
		dir_contents(music_folder.get_current_dir() + "/Intro/")
	elif music_folder.dir_exists("Loop/"):
		dir_contents(music_folder.get_current_dir() + "/Loop/")
	return 
# ─────────────────────────────────────────────
# LOAD ALL TRACKS FROM A FOLDER
# ─────────────────────────────────────────────
func dir_contents(folder_path):
	var dir = DirAccess.open(folder_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			
			if dir.current_is_dir():
				print("Found directory: " + file_name)
				
			elif file_name.ends_with(".ogg"):
				var track_dir = folder_path + file_name
				if Toggle_Debug == true:
					print("Found file: " + track_dir)
					
				# ─────────────────────────────────────────────
				# calls the bus creator while sending the trimmed file name + the file path of the track
				create_bus(file_name, track_dir)
				#select the last playing track and send signals on finished
				players[-1].connect("finished", Callable(self, "_on_player_finished"))
				# ─────────────────────────────────────────────
			file_name = dir.get_next()
	else:
		push_error("Received An Invalid Folder Path.")
	return
# ─────────────────────────────────────────────
# CREATE DYNAMIC BUS FOR EACH TRACK
# ─────────────────────────────────────────────
func create_bus(bus_name,track_dir):
	var bus_idx = AudioServer.bus_count
	AudioServer.add_bus(bus_idx)
	AudioServer.set_bus_name(bus_idx, bus_name)
	bus_dict[bus_name] = 0
	
	var spectrum := AudioEffectSpectrumAnalyzer.new()
	AudioServer.add_bus_effect(bus_idx, spectrum, 0) # 0 = first effect slot
	
	if Toggle_Debug == true:
		if AudioServer.is_bus_effect_enabled(bus_idx, 0) == true:
			print("|Created bus:", bus_name, "|idx:", AudioServer.get_bus_index(bus_name), "|Audio effect:", spectrum)
		else:
			print("|Created bus:", bus_name, "|idx:", AudioServer.get_bus_index(bus_name),"|")
			push_warning("No Audio Effect Detected For |", bus_name, "|idx:", AudioServer.get_bus_index(bus_name),"|")

	play_music_on_bus(bus_name, track_dir)
	return
# ─────────────────────────────────────────────
# PLAYING EACH TRACKS INTO THEIR RESPECTIVE BUS
# ─────────────────────────────────────────────
func play_music_on_bus(bus_name,track_dir):
	var player := AudioStreamPlayer.new()

	players.append(player)
	add_child(player)
	
	player.stream = load(track_dir)
	player.bus = bus_name
	player.play()
	
	if Toggle_Debug == true:
		print("Playing ", track_dir, " on ", bus_name)
		print("──────────────────────────────────────────────────────────────────────────────────────────There is curently ", AudioServer.bus_count - 1, " generated busses")
	return
# ─────────────────────────────────────────────
# TURNING BUSSES GAIN INTO USABLE VALUES
# ─────────────────────────────────────────────
func gain_detector():
	for i in range(1, AudioServer.bus_count):
		var effect = AudioServer.get_bus_effect_instance(i, 0)
		var bus_key = AudioServer.get_bus_name(i)
		if effect is AudioEffectSpectrumAnalyzerInstance:
			var output: Vector2 = effect.get_magnitude_for_frequency_range(20, 40000)
			bus_dict[bus_key] = output.length()
	return
