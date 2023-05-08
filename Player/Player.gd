extends KinematicBody2D

export var speed = 400
export var health = 100
var reloading = false
var velocity = Vector2()
onready var WeaponManager = $WeaponManager

#AI
var AI = true
onready var Player = get_node("/root/GameScene/Jay")
var stop_distance = 150
var enemy_array = []
var enemy = null
var able_to_shoot = false
var ROF = true


func _ready():
	AI = Global.tom_ai

#Process the game
func _physics_process(_delta):
	AI = Global.tom_ai
	if AI:
		AI()
	else:
		player()
		
	


func reloading():
	reloading = true
func finished_reloading():
	reloading = false

#AI FUNCTION
func AI():
	$Camera2D.current = false
	if reloading:
		$AnimatedSprite.play("Reload")
	if Player:
		var direction = Player.position - position
		var distance = direction.length()
		if distance > stop_distance:
			velocity = direction.normalized() * speed
			move_and_slide(velocity)
			if not reloading:
				$AnimatedSprite.play("Walk")
		else:
			velocity = Vector2.ZERO
			if not reloading:
				$AnimatedSprite.play("Idle")
	if enemy_array.size() != 0:
		select_enemy()
		turn()
		able_to_shoot()
		if able_to_shoot and ROF:
			WeaponManager.shoot()
	else:
		enemy = null
		
#AI FUNCTION
func turn():
	if enemy != null:
		var target_rotation = global_position.direction_to(enemy.global_position).angle()
		var angle_difference = fmod(target_rotation - rotation, 360)
		if angle_difference < -180:
			angle_difference += 360
		if angle_difference > 180:
			angle_difference -= 360
		var turn_speed = 0.2
		if angle_difference < 0:
			turn_speed *= -1
		rotation += turn_speed * abs(angle_difference)
		
		
#AI FUNCTION
func able_to_shoot():
	var direction_to_enemy = enemy.global_position - global_position
	var angle_to_enemy = direction_to_enemy.angle()
	var forward = Vector2(1, 0).rotated(rotation)
	var dot = forward.dot(direction_to_enemy.normalized())

	if dot > 0.95:
		able_to_shoot = true
	else:
		able_to_shoot = false
#AI FUNCTION
func select_enemy():
	var closest_distance = 99999999
	for e in enemy_array:
		var distance = global_position.distance_to(e.global_position)
		if distance < closest_distance:
			enemy = e
			closest_distance = distance

#AI FUNCTION
func _on_shootRadius_body_entered(body):
	if body.is_in_group("Enemy"):
		enemy_array.append(body)

#AI FUNCTION
func _on_shootRadius_body_exited(body):
	if body.is_in_group("Enemy"):
		enemy_array.erase(body)


#Get user input for player movement
func player():
	get_input()
	move_and_slide(velocity)
	$Camera2D.current = true
#PLAYER FUNCTION
func get_input():
	rotation = get_global_mouse_position().angle_to_point(position)
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
	#Animations
	if input_direction and not reloading:
		$AnimatedSprite.play("Walk")
	elif not reloading:
		$AnimatedSprite.play("Idle")
	elif reloading:
		$AnimatedSprite.play("Reload")
#Character die if health <= 0
func damage(damage):
	health -= damage
	Global.health = health
	if health <= 0:
		queue_free()



