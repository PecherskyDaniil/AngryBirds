extends Node2D

@onready var catapult=get_node("catapult")
var pigs_count=0
var bird_count=0
var won=false
func _ready() -> void:
	count_all_pigs()
	put_all_birds_in_bucket()

func put_all_birds_in_bucket():
	var objects=get_children()
	
	for object in objects:
		if "bird" in object.name:
			bird_count+=1
			catapult.put_to_bucket(object)

func count_all_pigs():
	var objects=get_children()
	
	for object in objects:
		if "pig" in object.name:
			pigs_count+=1

func _on_bird_dead() -> void:
	bird_count-=1
	if bird_count==0 and not won:
		loose()

func _on_pig_pig_dead() -> void:
	pigs_count-=1
	if pigs_count==0:
		won=true
		win()
func win():
	print("you won")
	
func loose():
	print("you loose")
