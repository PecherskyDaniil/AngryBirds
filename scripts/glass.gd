extends RigidBody2D

signal score_event(name,score_amount,pos)

var health:float=4.0
@onready var audio_player:AudioStreamPlayer=get_node("AudioStreamPlayer")
@onready var damage_sound=preload("res://audio/glass_sound.mp3")
@onready var animations=get_node("AnimationPlayer")
func _ready() -> void:
	update_state()

func update_state():
	if health>3.0:
		animations.play("damage0")
	elif health<=3.0 and health>2.0:
		animations.play("damage1")
	elif health<=2.0 and health>1.0:
		animations.play("damage2")
	elif health<=1.0:
		score_event.emit("object_destroyed",40,self.global_position)
		self.queue_free()
		

func damage(velocity:Vector2): # обработка удара по объекту
	health-=abs(velocity.length())/100
	if not(audio_player.playing):
		audio_player.stream=damage_sound
		audio_player.play()

func _on_audio_stream_player_finished() -> void:
	update_state()
