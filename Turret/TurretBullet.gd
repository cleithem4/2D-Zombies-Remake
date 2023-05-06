extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 1000.0
var damage = 2

func _ready():
	pass

func _physics_process(delta):
	velocity = Vector2(speed, 0).rotated(rotation)
	position += velocity * delta


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Area2D_body_entered(body):
	if body.has_method("damage") and body.is_in_group("Enemy"):
		body.damage(damage)
		#Queue free so bullet disappear
		queue_free()



