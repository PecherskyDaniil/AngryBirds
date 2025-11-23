extends RigidBody2D

signal score_event(name,score_amount,pos)

var health:float=30.0
@onready var animations=get_node("AnimationPlayer")
func _ready() -> void:
	update_state()

func update_state():
	if health>29.0:
		animations.play("damage0")
	elif health<=29.0 and health>20.0:
		animations.play("damage1")
	elif health<=20.0 and health>10.0:
		animations.play("damage2")
	elif health<=10.0 and health>0.0:
		animations.play("damage3")
	elif health<=0.0:
		score_event.emit("object_destroyed",40,self.global_position)
		self.queue_free()

func damage(velocity:Vector2): # обработка удара по объекту
	health-=abs(velocity.length())/400
	update_state()
