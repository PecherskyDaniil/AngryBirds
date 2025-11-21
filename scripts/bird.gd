extends RigidBody2D

signal bird_dead
@onready var collision:CollisionShape2D=get_node("CollisionShape2D")
const DEAD_TIME=2.0

var is_active=false
var dead_time_remains=DEAD_TIME
func _ready() -> void:
	self.set_max_contacts_reported(2)

func _process(delta: float) -> void:
	handle_collisions()
	if is_active and abs(linear_velocity.length())<10:
		dead_time_remains-=delta
	else:
		dead_time_remains=DEAD_TIME
	if dead_time_remains<=0:
		bird_dead.emit()
		self.queue_free()
	
func to_passive_state():
	is_active=false
	collision.disabled=true
	self.freeze=true

func to_active_state():
	is_active=true
	collision.disabled=false
	self.freeze=false

func handle_collisions():
	var colliders=self.get_colliding_bodies()
	for collider in colliders:
		if collider.has_method("damage"):
			collider.damage(self.linear_velocity)
