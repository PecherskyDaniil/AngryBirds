extends Node2D


func _on_volume_changed(value: float) -> void:
	var bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_linear(bus, value)


func _on_back_pressed() -> void:
	visible=false
