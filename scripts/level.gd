extends Node2D

@onready var catapult=get_node("catapult")
@onready var label = get_node("Score_anim_label")
@onready var result_panel=get_node("ResultPanel")
@onready var camera:Camera2D=get_node("Camera2D")
@onready var pause=get_node("Pause")
@export var level_number:int=0
@export var MAX_SCORE=600.0
var detect_object:Node


var score:int=0
var stars=0


var won=false
var bird_count=0
var pigs_count=0

var tween: Tween

var camera_tween:Tween


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and not won:
		if pause.visible:
			pause.visible=false
			Autoload.resume()
		else:
			pause.visible=true
			Autoload.pause()

func show_text_at_position(text: String, pos: Vector2, duration: float = 1.0):
	# Устанавливаем текст и позицию
	label.text = text
	label.global_position = pos
	label.modulate.a = 1.0

	# Создаем твин для анимации
	if tween:
		tween.kill()
	tween = create_tween()
	
	# Анимация появления
	#tween.tween_property(label, "modulate:a", 1.0, duration)
	tween.tween_property(label,"global_position:y",label.global_position.y-100.0,duration)
	#tween.tween_interval(2.0)
	tween.tween_property(label, "modulate:a", 0.0, duration)


func _ready() -> void:
	camera.limit_left=0
	camera.limit_bottom=648
	camera.limit_top=0
	camera.limit_right=1152
	put_all_birds_in_bucket()
	count_all_pigs()


func _process(delta: float) -> void:
	handle_camera(delta)

func put_all_birds_in_bucket():
	var objects=get_children()
	
	for object in objects:
		if "bird" in object.name:
			bird_count+=1
			score+=100
			catapult.put_to_bucket(object)

func get_score(event_name:String,rewarded_score:int,pos:Vector2):
	show_text_at_position(str(rewarded_score), pos, 0.5)
	score+=rewarded_score
	match event_name:
		"pig_killed":
			pigs_count-=1
		"bird_died":
			detect_object=null
			bird_count-=1
	
	if pigs_count==0:
		won=true
		win()
	if bird_count==0 and not won:
		loose()

func count_all_pigs():
	var objects=get_children()
	
	for object in objects:
		if "pig" in object.name:
			pigs_count+=1

func win():
	Autoload.progress[level_number][0]=int((float(score)/MAX_SCORE)*3.0)
	result_panel.appear(level_number,"win",score)
	
func loose():
	result_panel.appear(level_number,"loose",0)


func handle_camera(delta):
	if detect_object == null:
		move_camera_to_base()
	else:
		camera_detect()

func move_camera_to_base():
	detect_object=catapult
	camera.global_position=Vector2(576.0,332.0)
	camera.zoom=Vector2(1.3,1.3)

func camera_detect():
	camera.global_position=detect_object.global_position
	camera.global_position.y+=40
	




func _on_catapult_grab(object: Variant) -> void:
	print("grab")
	detect_object=object
	camera.zoom=Vector2(1.0,1.0)



func _on_catapult_release() -> void:
	print("release")
	detect_object=null
	camera.zoom=Vector2(1.3,1.3)



func _on_catapult_throw(bird: Variant) -> void:
	detect_object=bird
	camera.zoom=Vector2(1.3,1.3)
