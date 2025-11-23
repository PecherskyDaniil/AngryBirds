extends Node2D
var levels=[]
func _ready() -> void:
	for i in range(0,Autoload.progress.size()):
		var level_select=preload("res://scenes/level_select.tscn").instantiate()
		level_select.update_level(str(i),Autoload.progress[i][0],Autoload.progress[i][1])
		level_select.global_position.x=100+100*i
		level_select.global_position.y=100
		add_child(level_select)
		levels.append(level_select)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
