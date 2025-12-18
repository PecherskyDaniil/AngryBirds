extends RigidBody2D

signal score_event(name,score_amount,pos)
var textures = ["res://assets/pig-1.png","res://assets/pig-2.png","res://assets/pig-3.png","res://assets/pig-4.png"]
@onready var sprite:Sprite2D=$Sprite2D
var health:float=1.0



func _ready() -> void:
	update_state()
	var texture=textures[randi_range(0,3)]
	sprite.texture=load(texture)

func update_state():
	if health<=0:
		score_event.emit("pig_killed",200,self.global_position)
		self.queue_free()
		
func damage(velocity:Vector2): # обработка удара по объекту
	health-=abs(velocity.length())/300
	update_state()
