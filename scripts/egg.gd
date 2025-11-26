extends RigidBody2D



signal score_event(name,score_amount,pos)# сигнал для обработки смерти птички и чтоб считать очки

@onready var collision:CollisionShape2D=get_node("CollisionShape2D") # колизии
@onready var explosion:Area2D=get_node("Area2D")
func _ready() -> void:
	self.set_max_contacts_reported(5)
	self.contact_monitor=true

func _process(delta: float) -> void:
	handle_collisions() # обрабатываем абилки

func handle_collisions():
	var colliders=self.get_colliding_bodies()
	for collider in colliders:
		if "bird" not in collider.name:
			explode()
			self.queue_free()

func explode():
	var bodies = explosion.get_overlapping_bodies()
	for body in bodies:
		if body is RigidBody2D and body.has_method("damage"):
			var direction = body.global_position - self.global_position
			direction = direction.normalized()
			var force_magnitude = 10000  # настройте по желанию
			var impulse = direction * force_magnitude
			body.apply_central_impulse(impulse)
			body.damage(Vector2(100,100))
