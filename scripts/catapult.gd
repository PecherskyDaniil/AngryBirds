extends Node2D

const THROW_STRENGTH=10.0

var grab_area_radius=30.0
var move_area_radius=100.0
var birds:Array[RigidBody2D]=[]
var grabbed=false
@onready var bucket:Node2D=get_node("bucket")
@onready var ready_position=get_node("ready_position")



var ready_bird:RigidBody2D=null

func _process(delta: float) -> void:
	var on_ready_bird=ready_position.get_children()
	handle_grab(delta)
	if grabbed and abs(get_global_mouse_position()-ready_position.global_position).length()<move_area_radius:
		ready_bird.global_position=get_global_mouse_position()
	if not ready_bird:
		var birds=bucket.get_children()
		if birds.size()>0:
			var bird=birds[0]
			put_to_ready_position(bird)

func handle_grab(delta):
	if Input.is_action_just_pressed("grab") and abs(get_global_mouse_position()-ready_position.global_position).length()<grab_area_radius:
		grabbed=true
	if Input.is_action_just_released("grab") and grabbed:
		grabbed=false
		if abs(get_global_mouse_position()-ready_position.global_position).length()<grab_area_radius:
			ready_bird.global_position=ready_position.global_position
		else:
			var move_vector=THROW_STRENGTH*-1*(ready_bird.global_position-ready_position.global_position)
			ready_position.remove_child(ready_bird)
			get_parent().add_child(ready_bird)
			ready_bird.global_position=ready_position.global_position
			ready_bird.to_active_state()
			ready_bird.apply_impulse(move_vector)
			ready_bird=null

func put_to_bucket(object):
	#object.global_position=bucket.global_position
	object.to_passive_state()
	var old_parent=object.get_parent()
	if old_parent:
		old_parent.remove_child(object)
	bucket.add_child(object)
	object.position.x=bucket.position.x+150.0-bucket.get_children().size()*40.0

func put_to_ready_position(object):
	var old_parent=object.get_parent()
	if old_parent:
		old_parent.remove_child(object)
	ready_position.add_child(object)
	object.global_position=ready_position.global_position
	ready_bird=object
	print(object.get_parent())
