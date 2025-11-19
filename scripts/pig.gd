extends RigidBody2D

var health:float=1.0
func _ready() -> void:
	update_state()

func update_state():
	if health<=0:
		self.queue_free()

func damage(velocity:Vector2):
	health-=abs(velocity.length())/300
	update_state()
