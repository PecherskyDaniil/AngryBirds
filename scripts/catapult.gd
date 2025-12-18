extends Node2D

signal throw(bird) # Сигнал для камеры на кидание
signal grab(object) # Сигнал для камеры на взятие
signal release # Сигнал для камеры на отпускание


const THROW_STRENGTH=10.0 # Сила броска

var grab_area_radius=30.0 # размер области хватания птички
var move_area_radius=100.0 # размер области оттягивания (фимоза)
var birds:Array[RigidBody2D]=[] # Список птичек в катапульте
var grabbed=false # Флаг на хвататние птичики
@onready var bucket:Node2D=get_node("bucket") # Ведро с птицами
@onready var ready_position=get_node("ready_position") # Спот для птицы на низком старте
@onready var audio_player:AudioStreamPlayer=get_node("AudioStreamPlayer")
@onready var rubby_sound=preload("res://audio/rubby.mp3")
@onready var throw_sound=preload("res://audio/throw.mp3")

var ready_bird:RigidBody2D=null # Птица на низком старте

func _process(delta: float) -> void:
	
	handle_grab(delta) # обрабатываем хватания и отпускания
	if grabbed and ready_bird !=null: # Это для того чтобы птичка следовала за курсором
		if not(audio_player.playing):
			audio_player.play(0.0)
		if abs(get_global_mouse_position()-ready_position.global_position).length()>move_area_radius:
			ready_bird.global_position=ready_position.global_position+(get_global_mouse_position()-ready_position.global_position).normalized()*move_area_radius
		else:
			ready_bird.global_position=get_global_mouse_position()
	if not ready_bird: # Если птичик на готове нет то готовим
		var birds=bucket.get_children()
		if birds.size()>0: # Это если птички совсем кончились
			var bird=birds[0]
			for bird_in_bucket in birds:
				bird_in_bucket.position.x=bird_in_bucket.position.x+40
			put_to_ready_position(bird)

func handle_grab(delta): # Обработка взятий,отпусканий и т.д.
	if Input.is_action_just_pressed("grab") and abs(get_global_mouse_position()-ready_position.global_position).length()<grab_area_radius: # Если взяли в области то хватаем птичку
		grabbed=true
		grab.emit(self)
		audio_player.stream=rubby_sound
	if Input.is_action_just_released("grab") and grabbed:# Если отпустили
		grabbed=false # от отпускаем
		if abs(get_global_mouse_position()-ready_position.global_position).length()<grab_area_radius: # Если мало оттянули - кладем на место
			release.emit()
			ready_bird.global_position=ready_position.global_position
		else:# Иначе отправляем в полет
			audio_player.stop()
			audio_player.stream=throw_sound
			audio_player.play(0.0)
			var move_vector=THROW_STRENGTH*-1*(ready_bird.global_position-ready_position.global_position)
			ready_position.remove_child(ready_bird)
			get_parent().add_child(ready_bird)
			ready_bird.global_position=ready_position.global_position
			ready_bird.to_active_state()
			ready_bird.apply_impulse(move_vector)
			throw.emit(ready_bird)
			ready_bird=null

func put_to_bucket(object): # Тут кладем птичку в ведро
	#object.global_position=bucket.global_position
	object.to_passive_state()
	var old_parent=object.get_parent()
	if old_parent:
		old_parent.remove_child(object)
	bucket.add_child(object)
	object.position.x=bucket.position.x+100.0-bucket.get_children().size()*40.0

func put_to_ready_position(object): #А тут кладем её на старт
	var old_parent=object.get_parent()
	if old_parent:
		old_parent.remove_child(object)
	ready_position.add_child(object)
	object.global_position=ready_position.global_position
	ready_bird=object
	print(object.get_parent())
