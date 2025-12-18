extends RigidBody2D



signal score_event(name,score_amount,pos)# сигнал для обработки смерти птички и чтоб считать очки

@onready var collision:CollisionShape2D=get_node("CollisionShape2D") # колизии
@onready var sprite:Sprite2D=$Sprite2D
const DEAD_TIME=3.0 # время смерти, дад дада

var is_active=false # флаг на кидание
var dead_time_remains=DEAD_TIME #таймер смерти
var ability_used=false # флаг что абилка юзнута
var punched=false
@onready var parent=get_parent()
@onready var egg:PackedScene=preload("res://scenes/egg.tscn")
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
	self.linear_velocity.y-=500
	sprite.region_rect=Rect2(360,60,156,172)
	var egg1=egg.instantiate()
	egg1.global_position=global_position
	egg1.global_position.y+=40
	egg1.linear_velocity.y+=1000
	parent.add_child(egg1)
	

func handle_collisions():
	var colliders=self.get_colliding_bodies()
	for collider in colliders:
		ability_used=true
		punched=true
		if collider.has_method("damage") and self.linear_velocity.length()>20.0:
			collider.damage(self.linear_velocity)
