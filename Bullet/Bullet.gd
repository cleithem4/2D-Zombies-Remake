extends KinematicBody2D


var velocity = Vector2.ZERO
var speed = 1000.0
var damage = 2

onready var smoketrail = $Smoketrail

func _physics_process(delta):
	velocity = Vector2(0, speed).rotated(rotation)
	position += velocity * delta
	smoketrail.add_point(global_position)
	
func _on_Area2D_body_entered(body):
	smoketrail.stop()
	if body.has_method("damage"):
		body.damage(damage)
		#Queue free so bullet disappear
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	##Queue free bullet avoid crashing
	queue_free()


func _on_Area2D_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	queue_free()


func _on_Area2D_area_entered(area):
	queue_free()
