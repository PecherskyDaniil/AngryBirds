extends Node2D

@onready var catapult=get_node("catapult")
var number=1
var stars=2
func _ready() -> void:
	put_all_birds_in_bucket()

func put_all_birds_in_bucket():
	var objects=get_children()
	
	for object in objects:
		if "bird" in object.name:
			catapult.put_to_bucket(object)
