extends Control

@export var level_number:int=0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if self.visible:
			self.visible=false
			Autoload.resume()


func _on_resume_pressed() -> void:
	self.visible=false
	Autoload.resume()


func _on_to_select_level_pressed() -> void:
	Autoload.resume()
	get_tree().change_scene_to_file("res://scenes/level_selector.tscn")


func _on_retry_pressed() -> void:
	Autoload.resume()
	get_tree().change_scene_to_file(Autoload.progress[level_number][1])
