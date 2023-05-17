extends KinematicBody2D

export var speed = 380
export var health = 100
var velocity = Vector2.ZERO
var reloading = false
onready var Bullet = load("res://Bullet/Bullet.tscn")
onready var player = get_node("/root/GameScene/CharacterSelection/Player")
onready var downed_bar = $DownedBar
onready var dialogue = $Node2D/Label
onready var WeaponManager = $WeaponManager
var current_weapon = null
var two_handed_weapon = false

#AI
var AI = false
var too_close_distance = 80
var stop_distance = 150
var enemy_array = []
var enemy = null
var able_to_shoot = false


#Player
var ai_array = []
var closest_ai = null
var regen_health = true
var downed = false
var downedArea = []

func _ready():
	get_two_handed_weapon()
	AI = Global.jay_ai

func get_two_handed_weapon():
	if Global.jay_weapon.getGunName() == "AK47":
		$AnimatedSprite.speed_scale = 1
		two_handed_weapon = true
	elif Global.jay_weapon.getGunName() == "Pistol":
		$AnimatedSprite.speed_scale = 1
		two_handed_weapon = false
	elif Global.jay_weapon.getGunName() == "RPD":
		$AnimatedSprite.speed_scale = 0.5
		two_handed_weapon = true
	elif Global.jay_weapon.getGunName() == "Custom SMG":
		$AnimatedSprite.speed_scale = 1
		two_handed_weapon = false
	elif Global.jay_weapon.getGunName() == "Ray Gun":
		$AnimatedSprite.speed_scale = 1
		two_handed_weapon = false
	elif Global.jay_weapon.getGunName() == "M24":
		$AnimatedSprite.speed_scale = 0.65
		two_handed_weapon = true
func get_ai_name():
	return "Jay"
func reloading():
	reloading = true
func finished_reloading():
	reloading = false
	$reload.play()
func getAI():
	return AI




#Process the game
func _physics_process(_delta):
	player = Global.current_player
	current_weapon = Global.jay_weapon
	AI = Global.jay_ai
	if downed:
		downed_bar.show()
		current_weapon.hide()
		return
	else:
		downed_bar.hide()
		current_weapon.show()
	if AI:
		AI()
	else:
		player()
		
#AI FUNCTION
func AI():
	regenerateHealth()

	$Camera2D.current = false
	get_two_handed_weapon()
	
	if reloading:
		if not two_handed_weapon:
			$AnimatedSprite.play("ReloadPistol")
		else:
			$AnimatedSprite.play("Reload")
	if player:
		var direction = player.position - position
		var distance = direction.length()
		if distance > stop_distance:
			velocity = direction.normalized() * speed
			move_and_slide(velocity)
			if not reloading:
				if not two_handed_weapon:
					$AnimatedSprite.play("WalkPistol")
				else:
					$AnimatedSprite.play("Walk")
		elif too_close_distance > distance:
			velocity = -1 * direction.normalized() * speed
			move_and_slide(velocity)
			if not reloading:
				if not two_handed_weapon:
					$AnimatedSprite.play("WalkPistol")
				else:
					$AnimatedSprite.play("Walk")
		else:
			velocity = Vector2.ZERO
			if not reloading:
				if not two_handed_weapon:
					$AnimatedSprite.play("WalkPistol")
				else:
					$AnimatedSprite.play("Idle")
	if enemy_array.size() != 0:
		select_enemy()
		turn()
		able_to_shoot()
		if able_to_shoot:
			WeaponManager.shoot()
	else:
		enemy = null


func player():
	regenerateHealth()
	Global.health = health
	$Camera2D.current = true
	get_two_handed_weapon()
	get_input()
	velocity = move_and_slide(velocity)
	if ai_array.size() != 0:
		select_ai()
	else:
		closest_ai = null
		Global.closest_ai = closest_ai



#PLAYER FUNCTION
func get_input():
	if AI:
		return
	rotation = get_global_mouse_position().angle_to_point(position)
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
	#Animations
	if input_direction and not reloading:
		if not two_handed_weapon:
			$AnimatedSprite.play("WalkPistol")
		else:
			$AnimatedSprite.play("Walk")
	elif not reloading:
		if not two_handed_weapon:
			$AnimatedSprite.play("IdlePistol")
		else:
			$AnimatedSprite.play("Idle")
	elif reloading:
		if not two_handed_weapon:
			$AnimatedSprite.play("ReloadPistol")
		else:
			$AnimatedSprite.play("Reload")





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

#Character die if health <= 0
func damage(damage):
	health -= damage
	$hit.play()
	if not AI:
		Global.health = health
	if health <= 0 and not downed:
		downed()

#PLAYER FUNCTION
func regenerateHealth():
	if health < 100:
		health += 0.1




#PLAYER FUNCTION
func select_ai():
	var closest_ai_distance = 99999999
	for a in ai_array:
		var distance = global_position.distance_to(a.global_position)
		if distance < closest_ai_distance:
			closest_ai = a
			closest_ai_distance = distance
	Global.closest_ai = closest_ai

func _on_closestAI_body_entered(body):
	if body.is_in_group("AI") and body != self:
		ai_array.append(body)

func downed():
	downedArea.clear()
	Global.player_in_downed_area = downedArea.size() != 0
	get_parent().update_players()
	if is_in_group("AI"):
		self.remove_from_group("AI")
	if is_in_group("Player"):
		self.remove_from_group("Player")
	downed = true
	$AnimatedSprite.play("down")
	$AnimatedSprite.speed_scale = 0.4
	speed = 10
	for playerAlive in Global.all_ai:
		if not is_instance_valid(playerAlive):
			continue
		if playerAlive.get_ai_name() != "FreeRoamCamera" and playerAlive.get_ai_name() != get_ai_name() and playerAlive.health > 0:
			Global.current_player = playerAlive
			Global.refresh_ai()
			return
	get_tree().change_scene("res://UI/Game_Over.tscn")

func revived():
	downedArea.clear()
	self.add_to_group("AI")
	self.add_to_group("Player")
	downed = false
	speed = 380
	health = 100
	$AnimatedSprite.speed_scale = 1
	


func _on_closestAI_body_exited(body):
	if body.is_in_group("AI"):
		ai_array.erase(body)





func _on_downed_body_entered(body):
	if body.is_in_group("AI") and body != self and downed:
		downedArea.append(body)
		print(downedArea)
		Global.player_in_downed_area = downedArea.size() != 0

func _on_downed_body_exited(body):
	if body.is_in_group("AI") and body != self and downed:
		downedArea.erase(body)
		print(downedArea)
		Global.player_in_downed_area = downedArea.size() != 0
