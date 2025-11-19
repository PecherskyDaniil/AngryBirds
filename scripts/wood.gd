extends RigidBody2D

var health:float=5.0

@onready var animations=get_node("AnimationPlayer")
func _ready() -> void:
	update_state()

func update_state():
	if health>4.0:
		animations.play("damage0")
	elif health<=4.0 and health>3.0:
		animations.play("damage1")
	elif health<=3.0 and health>2.0:
		animations.play("damage2")
	elif health<=2.0 and health>0.0:
		animations.play("damage3")
	elif health<=0.0:
		self.queue_free()

func damage(velocity:Vector2):
	health-=abs(velocity.length())/200
	update_state()
