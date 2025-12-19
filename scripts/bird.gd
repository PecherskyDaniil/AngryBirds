extends RigidBody2D

signal score_event(name,score_amount,pos) #сигнал для считывания смерти птички и очков за смерть. Привязывать к get_score узла уровня 

@onready var collision:CollisionShape2D=get_node("CollisionShape2D") #колизии птички
@onready var audio_player:AudioStreamPlayer=$AudioStreamPlayer
@onready var fly_sound=preload("res://audio/birds_sounds/bird-01-flying.mp3")
@onready var collision_sound=preload("res://audio/birds_sounds/bird-01-collision-a1.mp3")
@onready var die_sound=preload("res://audio/birds_sounds/bird-destroyed.mp3")
const DEAD_TIME=3.0 # Время бездействия птички после которого она умирает

var is_active=false # Флаг того что птичку отправили в полет
var dead_time_remains=DEAD_TIME # таймер на жизнь птички
var punched=false#ударилась ли птичка
func _ready() -> void:
	audio_player.volume_db=-40.0
	self.set_max_contacts_reported(5) # это для обработки Прикосновений
	# ВНИМАНИЕ ЕСЛИ БУДЕТЕ ДЕЛАТЬ НОВУЮ ПТИЧКУ ВКЛЮЧИТЕ ЕЙ (rigid body) ПАРАМЕТР CONTACT MONITOR - ON и MAX CONTACTS REPOTS - 5
	self.contact_monitor=true



func _process(delta: float) -> void:
	handle_collisions() # Обрабатываем прикосновения
	if is_active and punched: # Чекаем жива ли
		dead_time_remains-=delta # если не особо то сокращаем жизнь
	else:
		dead_time_remains=DEAD_TIME # а если все норм то сбрасываем таймер
	if dead_time_remains<=0: # Если таймер вышел - убиваем
		score_event.emit("bird_died",-100,self.global_position)
		self.queue_free()
	
func to_passive_state(): # в пассивное состояние для того чтобы спойно целиться и стрелять
	is_active=false
	collision.disabled=true
	self.freeze=true

func to_active_state(): # в активное состояние для полета и удара
	audio_player.stream=fly_sound
	audio_player.play()
	is_active=true
	collision.disabled=false
	self.freeze=false

func handle_collisions(): # обрабатываем прикосновения
	var colliders=self.get_colliding_bodies() # список касающихся объектов
	for collider in colliders:
		if punched==false:
			audio_player.stream=collision_sound
			audio_player.play()
			punched=true
		if collider.has_method("damage") and self.linear_velocity.length()>20.0: # если можно ударить и скорость позволяет - то бьем
			collider.damage(self.linear_velocity) # передаем скорость в функцию удара
