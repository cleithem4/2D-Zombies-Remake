extends KinematicBody2D


var velocity = Vector2.ZERO
var speed = 1000.0
var damage = 3

var direction = Vector2.ZERO


func _physics_process(delta):
	if direction != Vector2.ZERO:
		velocity = speed * direction * delta
	global_position += velocity


func _on_Area2D_body_entered(body):
	if body.is_in_group("Enemy"):
		body.damage(damage * Global.damageModifier,false,direction,true)
		#Queue free so bullet disappear
		queue_free()
	if body.is_in_group("Object") and not body.is_in_group("Player"):
		queue_free()
func set_direction(direction):
	self.direction = direction
func _on_VisibilityNotifier2D_screen_exited():
	##Queue free bullet avoid crashing
	queue_free()



func _on_Area2D_area_entered(area):
	if area.is_in_group("Head"):
		area.get_parent().damage(damage * 2 * Global.damageModifier,true,direction,true)
		queue_free()

		


func _on_life_timeout():
	queue_free()
