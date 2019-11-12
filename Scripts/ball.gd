extends RigidBody2D

export var maxspeed = 1000
export var size_decay = 0.3
export var alpha_decay = 0.03

var count = 0

signal lives
signal score

func _ready():
 contact_monitor = true
 set_max_contacts_reported(4)
 var WorldNode = get_node("/root/World")
 connect("score", WorldNode, "increase_score")
 connect("lives", WorldNode, "decrease_lives")

func _physics_process(delta):
 var bodies = get_colliding_bodies()
 for body in bodies:
	get_parent().get_node("Camera").add_trauma(0.5)
  if body.is_in_group("Tiles"):
   emit_signal("score",body.score)
   body.queue_free()
  if body.get_name() == "Paddle":
   pass
  
 if position.y > get_viewport_rect().end.y:
  emit_signal("lives")
  queue_free()
  
 if position.y > get_viewport_rect().end.y:
  emit_signal("lives")
  queue_free()

var temp = $ColorRect.duplicate()
	temp.rect_position = Vector2(position.x + $ColorRect.rect_position.x,position.y + $ColorRect.rect_position.y)
	temp.name = "Trail" + str(count)
	count += 1
	$Trail.add_child(temp)
	var trail = $Trail.get_children()
	for t in trail:
		t.rect_size = Vector2(t.rect_size.x-size_decay,t.rect_size.y-size_decay)
		t.color.a -= alpha_decay
		if t.color.a <= 0:
			t.color.a = 0
		if t.rect_size.x <= 0.5 or t.color.a <= 0:
			t.queue_free()
