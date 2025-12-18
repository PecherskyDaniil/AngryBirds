extends RigidBody2D


signal score_event(name,score_amount,pos)# сигнал для обработки смерти птички и чтоб считать очки

@onready var collision:CollisionShape2D=get_node("CollisionShape2D") # колизии
@onready var explosion:Area2D=get_node("Area2D")
const DEAD_TIME=2.0 # время смерти, дад дада

var is_active=false # флаг на кидание
var dead_time_remains=DEAD_TIME #таймер смерти
var ability_used=false # флаг что абилка юзнута
var punched = false
func _ready() -> void:
	self.set_max_contacts_reported(5)
	self.contact_monitor=true

func _process(delta: float) -> void:
	handle_collisions() # обрабатываем абилки
	handle_ability()
	
	if is_active and punched:
		dead_time_remains-=delta
	else:
		dead_time_remains=DEAD_TIME
	if dead_time_remains<=0:
		if not ability_used:
			ability()
		score_event.emit("bird_died",-100,self.global_position)
		self.queue_free()
	
func to_passive_state():
	is_active=false
	collision.disabled=true
	self.freeze=true

func to_active_state():
	is_active=true
	collision.disabled=false
	self.freeze=false

func handle_ability():
	if is_active and Input.is_action_just_pressed("ability") and not ability_used:
		ability()
		ability_used=true

func ability():
	var sprite=$Sprite2D
	sprite.region_rect=Rect2(376.0,68.0,112.0,156.0)
	var bodies = explosion.get_overlapping_bodies()
	for body in bodies:
		if body is RigidBody2D and body.has_method("damage"):
			var direction = body.global_position - self.global_position
			direction = direction.normalized()
			var force_magnitude = 10000  # настройте по желанию
			var impulse = direction * force_magnitude
			body.apply_central_impulse(impulse)
			body.damage(Vector2(1000,1000))

func handle_collisions():
	var colliders=self.get_colliding_bodies()
	for collider in colliders:
		punched=true
		if collider.has_method("damage") and self.linear_velocity.length()>20.0:
			collider.damage(self.linear_velocity)
