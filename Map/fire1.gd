extends AnimatedSprite



func _ready():
	pass


func _on_Area2D_body_entered(body):
	if body.is_in_group("Enemy") or body.is_in_group("AI"):
		body.emit_signal("on_fire",4)
