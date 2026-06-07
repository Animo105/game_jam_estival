extends OmniLight3D
@export var Instrument = "1.ogg"
@export var Sound_sensitivity = 0

func _ready():
	if AudioServer.get_bus_index(Instrument) == -1 && Instrument != "":
		push_warning("Can't find any audio bus with the name: ", Instrument)
	return
func _process(_delta: float) -> void:
	if IMM.bus_dict.has(Instrument):
		#change this varriable to anything you want bouncing
		light_energy = IMM.bus_dict[Instrument] * Sound_sensitivity
		print(light_energy)
	return
