extends RigidBody2D

signal score_event(name,score_amount,pos)
var textures = ["res://assets/pig-1.png","res://assets/pig-2.png","res://assets/pig-3.png","res://assets/pig-4.png"]
@onready var sprite:Sprite2D=$Sprite2D
@onready var audio_player:AudioStreamPlayer=$AudioStreamPlayer
@onready var default_sound=preload("res://audio/birds_sounds/piglette-oink-a8.mp3")
@onready var collision_sound=preload("res://audio/birds_sounds/piglette-damage-a4.mp3")
var health:float=1.0

var oink_wait_time:float


	

func _ready() -> void:
	audio_player.volume_db=-40.0
	oink_wait_time=randf_range(4.0,10.0)
	update_state()
	var texture=textures[randi_range(0,3)]
	sprite.texture=load(texture)
	
func _process(delta: float) -> void:
	if oink_wait_time>0:
		oink_wait_time-=delta
	else:
		audio_player.stream=default_sound
		audio_player.play()
		oink_wait_time=randf_range(4.0,10.0)
func update_state():
	if health<=0:
		if !(audio_player.stream==collision_sound and audio_player.playing):
			audio_player.stream=collision_sound
			audio_player.play()
		
		
func damage(velocity:Vector2): # обработка удара по объекту
	
	health-=abs(velocity.length())/300
	update_state()


func _on_audio_stream_player_finished() -> void:
	if audio_player.stream==collision_sound:
		score_event.emit("pig_killed",200,self.global_position)
		self.queue_free()
