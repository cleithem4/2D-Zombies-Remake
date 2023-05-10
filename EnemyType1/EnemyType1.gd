extends KinematicBody2D

export var speed = 300
export var health = 10

var motion = Vector2.ZERO
var attackDmg = 10
var able_to_attack = true
onready var Blood = load("res://Particles/Blood.tscn") 
var in_attack_range = []
var target = []
var closest_target = null
#Process the game 
func _physics_process(_delta):
	motion = Vector2.ZERO
# warning-ignore:standalone_expression
	if target.size() != 0:
		select_target()
		motion = position.direction_to(closest_target.position) * speed 
		look_at(closest_target.position)
		motion = move_and_slide(motion)
	if able_to_attack:
		for body in in_attack_range:
			body.damage(attackDmg)
			able_to_attack = false

#Check if player collide or not
func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		target.append(body)
		$Area2D/Moan.play()
		$AnimatedSprite.play("Walk")

#Zombie dies if health <= 0
func damage(dmg):
	health -= dmg
	Global.score += 5
	
	#adds blood to zombie each time they get shot
	var blood = Blood.instance()
	get_tree().current_scene.add_child(blood)
	blood.global_position = global_position
	
	
	if health <= 0:
		Global.score += 30
		get_parent().on_zombie_killed()
		queue_free()

func _on_AttackRange_body_entered(body):
	if body.has_method("damage") and body.is_in_group("Player"):
		$CollisionShape2D/Bite.play()
		in_attack_range.append(body)


func _on_AttackSpeed_timeout():
	able_to_attack = true


func _on_AttackRange_body_exited(body):
	if body.is_in_group("Player"):
		in_attack_range.erase(body)


func _on_Area2D_body_exited(body):
	if body.is_in_group("Player"):
		target.erase(body)
func select_target():
	var closest_distance = 99999999
	for e in target:
		var distance = global_position.distance_to(e.global_position)
		if distance < closest_distance:
			closest_target = e
			closest_distance = distance
