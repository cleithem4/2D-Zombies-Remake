extends KinematicBody2D

export var speed = 350
export var health = 10

var motion = Vector2.ZERO
var attackDmg = 10
var player = null

onready var Blood = load("res://Particles/Blood.tscn") 

#Process the game 
func _physics_process(_delta):
	motion = Vector2.ZERO
# warning-ignore:standalone_expression
	player == null
	for p in $Area2D.get_overlapping_bodies():
		if p.is_in_group("Player"):
			player = p
	if player:
		motion = position.direction_to(player.position) * speed 
		look_at(player.position)
	motion = move_and_slide(motion)

#Check if player collide or not
func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		$Area2D/Moan.play()
		$AnimatedSprite.play("Walk")

#Zombie dies if health <= 0
func damage(dmg):
	health -= dmg
	
	#adds blood to zombie each time they get shot
	var blood = Blood.instance()
	get_tree().current_scene.add_child(blood)
	blood.global_position = global_position
	
	
	if health <= 0:
		Global.score += 50
		queue_free()

func _on_AttackRange_body_entered(body):
	if body.has_method("damage") and body.is_in_group("Player"):
		$CollisionShape2D/Bite.play()
		body.damage(attackDmg)
