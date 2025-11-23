extends Node2D

@onready var settings=get_node("Settings")

func _on_settings_pressed() -> void:
	settings.visible=true


func _on_exit_pressed() -> void:
	get_tree().quit()



func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_selector.tscn")
