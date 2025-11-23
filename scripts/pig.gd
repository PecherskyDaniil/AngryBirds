extends RigidBody2D

signal score_event(name,score_amount,pos)

var health:float=1.0



func _ready() -> void:
	update_state()

func update_state():
	if health<=0:
		score_event.emit("pig_killed",200,self.global_position)
		self.queue_free()

func damage(velocity:Vector2): # обработка удара по объекту
	health-=abs(velocity.length())/300
	update_state()
