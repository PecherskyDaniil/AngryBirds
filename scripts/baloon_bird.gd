extends RigidBody2D



signal score_event(name,score_amount,pos)# сигнал для обработки смерти птички и чтоб считать очки

@onready var collision:CollisionShape2D=get_node("CollisionShape2D") # колизии
const DEAD_TIME=5.0 # время смерти, дад дада

var is_active=false # флаг на кидание
var dead_time_remains=DEAD_TIME #таймер смерти
var ability_used=false # флаг что абилка юзнута
var punched=false
@onready var anim:AnimationPlayer=$AnimationPlayer
func _ready() -> void:
	self.set_max_contacts_reported(5)
	self.contact_monitor=true
	anim.play("small")

func _process(delta: float) -> void:
	handle_collisions() # обрабатываем абилки
	handle_ability()
	
	if is_active and punched:
		dead_time_remains-=delta
	else:
		dead_time_remains=DEAD_TIME
	if dead_time_remains<=4.0 and !ability_used:
		ability()
		ability_used=true
	if dead_time_remains<=0:
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
	anim.play("become_big")
	

func handle_collisions():
	var colliders=self.get_colliding_bodies()
	for collider in colliders:
		punched=true
		if collider.has_method("damage") and self.linear_velocity.length()>20.0:
			collider.damage(self.linear_velocity)
