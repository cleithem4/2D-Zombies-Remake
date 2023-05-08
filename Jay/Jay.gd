extends KinematicBody2D

export var speed = 380
export var health = 100
var current_clip = 30
var clip_size = 30
var velocity = Vector2.ZERO
var reloading = false
onready var Bullet = load("res://Bullet/Bullet.tscn")
onready var Player = get_node("/root/GameScene/Player")

var stop_distance = 150
onready var end_of_gun = $end_of_gun

var enemy_array = []
var enemy = null
var able_to_shoot = false
var ROF = true



func _ready():
	pass



func reload():
	reloading = true
	$AnimatedSprite.play("Reload")
	$Reload.start()


func shoot():
	if reloading:
		return
	current_clip -= 1
	if current_clip < 1:
		reload()
		
	var bullet = Bullet.instance()
	var target = enemy.global_position
	bullet.global_position = end_of_gun.global_position
	var direction_to_mouse = end_of_gun.global_position.direction_to(target)
	bullet.set_direction(direction_to_mouse)
	bullet.global_rotation = direction_to_mouse.angle() + 12345
	get_tree().get_current_scene().add_child(bullet)
	ROF = false
	$ROF.start()


		

#Process the game
func _physics_process(_delta):
	if Player:
		var direction = Player.position - position
		var distance = direction.length()
		if distance > stop_distance:
			velocity = direction.normalized() * speed
			move_and_slide(velocity)
			if not reloading:
				$AnimatedSprite.play("Walking")
		else:
			velocity = Vector2.ZERO
			if not reloading:
				$AnimatedSprite.play("Idle")
	if enemy_array.size() != 0:
		select_enemy()
		turn()
		able_to_shoot()
		if able_to_shoot and ROF:
			shoot()
	else:
		enemy = null


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

		
#Player die if health <= 0
func damage(damage):
	health -= damage
	if health <= 0:
		queue_free()
func able_to_shoot():
	var direction_to_enemy = enemy.global_position - global_position
	var angle_to_enemy = direction_to_enemy.angle()
	var forward = Vector2(1, 0).rotated(rotation)
	var dot = forward.dot(direction_to_enemy.normalized())

	if dot > 0.95:
		able_to_shoot = true
	else:
		able_to_shoot = false


func _on_Reload_timeout():
	reloading = false
	current_clip = clip_size
	$Reload.stop()

func select_enemy():
	var closest_distance = 99999999
	for e in enemy_array:
		var distance = global_position.distance_to(e.global_position)
		if distance < closest_distance:
			enemy = e
			closest_distance = distance

func _on_shootRadius_body_entered(body):
	if body.is_in_group("Enemy"):
		enemy_array.append(body)


func _on_shootRadius_body_exited(body):
	if body.is_in_group("Enemy"):
		enemy_array.erase(body)


func _on_ROF_timeout():
	ROF = true
	$ROF.stop()
