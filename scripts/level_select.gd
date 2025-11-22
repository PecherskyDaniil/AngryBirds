extends Node2D

var level_scene:PackedScene
func update_level(level_name:String, stars:int, level:PackedScene):
	level_scene=level
	var star_texture = preload("res://assets/star.png")
	var no_star_texture = preload("res://assets/no star.png")
	var label:Label = get_node("Button/CenterContainer/Label")
	var container:HBoxContainer = get_node("HBoxContainer")
	print(level_name)
	label.text = level_name
	if container:
		for child in container.get_children():
			child.queue_free()
		
		for i in stars:
			var star:TextureRect = TextureRect.new()
			star.texture=star_texture
			star.expand_mode=TextureRect.EXPAND_FIT_WIDTH
			container.add_child(star)
		
		for i in 3-stars:
			var no_star = TextureRect.new()
			no_star.texture=no_star_texture
			no_star.expand_mode=TextureRect.EXPAND_FIT_WIDTH
			container.add_child(no_star)


func _on_button_pressed() -> void:
	if level_scene:
		get_tree().change_scene_to_packed(level_scene)
