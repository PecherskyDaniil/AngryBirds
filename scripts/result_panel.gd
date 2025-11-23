extends Control

@onready var result_label=get_node("CenterContainer/VBoxContainer/ResultLabel")
@onready var score_label=get_node("CenterContainer/VBoxContainer/ScoreLabel")
@onready var next_level_button=get_node("CenterContainer/VBoxContainer/NextLevelButton")

var next_level:String
var current_level:String
func _ready() -> void:
	self.visible=false


func appear(level_number:int,result:String,score:int):
	Autoload.pause()
	current_level=Autoload.progress[level_number][1]
	match result:
		"win":
			result_label.text="YOU WON"
			if level_number<Autoload.progress.size()-1:
				next_level=Autoload.progress[level_number+1][1]
		"loose":
			result_label.text="YOU LOOSE"
			next_level_button.visible=false
	score_label.text=str(score)
	self.visible=true


func _on_levels_button_pressed() -> void:
	Autoload.resume()
	get_tree().change_scene_to_file("res://scenes/level_selector.tscn")


func _on_retry_button_pressed() -> void:
	Autoload.resume()
	get_tree().change_scene_to_file(current_level)




func _on_next_level_button_pressed() -> void:
	Autoload.resume()
	get_tree().change_scene_to_file(next_level)
