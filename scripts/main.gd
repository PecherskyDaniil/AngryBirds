extends Node2D

@onready var menu = get_node("Main menu")

func _ready()->void:
	load_settings()

func save_settings():
	var config = ConfigFile.new()
	var slider: HSlider = menu.get_node("Settings/CenterContainer/VBoxContainer/Volume")
	config.set_value("audio", "volume", slider.value)
	config.save("user://angry_birds.cfg")

func load_settings():
	var config = ConfigFile.new()
	var error = config.load("user://angry_birds.cfg")
	if error == OK:
		var slider:HSlider = menu.get_node("Settings/CenterContainer/VBoxContainer/Volume")
		var volume = config.get_value("audio", "volume", 0.0)
		slider.value = volume
		var bus = AudioServer.get_bus_index("Master")
		AudioServer.set_bus_volume_linear(bus, volume)
