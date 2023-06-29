extends KinematicBody2D

export var speed = 400
export var max_health = 100
var health = 100
var reloading = false
var velocity = Vector2()
onready var WeaponManager = $WeaponManager
onready var player = null
onready var downed_bar = $DownedBar
onready var animationPlayer = $AnimationPlayer
var current_weapon = null
var reloadTime = 1.0
#AI
var AI = true
var stop_distance = 150
var too_close_distance = 80
var enemy_array = []
var enemy = null
var able_to_shoot = false


#Player
var ai_array = []
var closest_ai = null
var regen_health = true
var downed = false
var downedArea = []

#Fire
signal on_fire(time)
var fireTime = 0
var onFire = false
var fire = null
onready var Fire = load("res://Particles/Fire.tscn")

#Perk
var drinkingPerk = false
var swiftSwig = false
var juggerJuice = false
var Perk = null

#Melee
onready var MeleeParticles = load("res://Particles/meleeCharge.tscn")
onready var MeleeParticlesTwo = load("res://Particles/meleeChargeTwo.tscn")
onready var MeleeParticlesThree = load("res://Particles/meleeChargeThree.tscn")
var playing = false
var stopped = false
var reverse = false
var melee = false
var meleeCooldown = false
var randomTimerStarted = false
var time = 0.0
var timeReset = false
var attackTime = 0.0
var meleeDamage = 0
var meleeMultiplier = 1
var lightAttackTime = 0.15
var heavyAttackStageOne = 0.16
var heavyAttackStageTwo = 0.3
var heavyAttackStageThree = 1
var heavyAttackStageFour = 1.6
var particles = null
var particlesTwo = null
var particlesThree = null
var particlesFour = null
var amountOfKnockback = 0


func _ready():
	AI = Global.george_ai
	current_weapon = Global.george_weapon
	get_weapon_speed()


#Process the game
func _physics_process(delta):
	time += delta
	player = Global.current_player
	current_weapon = Global.george_weapon
	AI = Global.george_ai
	if drinkingPerk:
		current_weapon.hide()
	else:
		current_weapon.show()
	if downed:
		downed_bar.show()
		current_weapon.hide()
		return
	elif not drinkingPerk:
		downed_bar.hide()
		current_weapon.show()
	if AI:
		AI()
	else:
		player()
		
		
	
func get_ai_name():
	return "George"
func get_weapon_speed():
	if Global.tom_weapon.getGunName() == "AK47":
		$AnimatedSprite.speed_scale = 1
		reloadTime = 1
	elif Global.tom_weapon.getGunName() == "Pistol":
		$AnimatedSprite.speed_scale = 1
		reloadTime = 1
	elif Global.tom_weapon.getGunName() == "RPD":
		$AnimatedSprite.speed_scale = 0.5
		reloadTime = 2
	elif Global.tom_weapon.getGunName() == "Custom SMG":
		$AnimatedSprite.speed_scale = 1
		reloadTime = 1
	elif Global.tom_weapon.getGunName() == "Ray Gun":
		$AnimatedSprite.speed_scale = 1
		reloadTime = 1
	elif Global.tom_weapon.getGunName() == "M24":
		$AnimatedSprite.speed_scale = 0.65
		reloadTime = 1.5
	elif Global.tom_weapon.getGunName() == "Pump-Shotgun":
		$AnimatedSprite.speed_scale = 0.85
		reloadTime = 1.2
	swiftSwig = Global.swiftSwig
	if swiftSwig:
		$AnimatedSprite.speed_scale = $AnimatedSprite.speed_scale*2
		reloadTime = float(reloadTime*0.5)

func reloading():
	reloading = true
func finished_reloading():
	$reload.play()
	reloading = false
func getAI():
	return AI
	



#AI FUNCTION
func AI():
	regenerateHealth()
	$Camera2D.current = false
	if player:
		var direction = player.position - position
		var distance = direction.length()
		if distance > stop_distance:
			velocity = direction.normalized() * speed
			move_and_slide(velocity)
			if not drinkingPerk and not melee:
				if reverse:
					$AnimatedSprite.play("WalkReverse")
				else:
					$AnimatedSprite.play("Walk")
		elif too_close_distance > distance:
			velocity = -1 * direction.normalized() * speed
			move_and_slide(velocity)
			if not drinkingPerk and not melee:
				if reverse:
					$AnimatedSprite.play("WalkReverse")
				else:
					$AnimatedSprite.play("Walk")
		else:
			velocity = Vector2.ZERO
			if not drinkingPerk and not melee:
				if reverse:
					$AnimatedSprite.play("IdleReverse")
				else:
					$AnimatedSprite.play("Idle")
	if enemy_array.size() != 0:
		select_enemy()
		turn()
		able_to_shoot = true
		#able_to_shoot()
		if able_to_shoot and not drinkingPerk:
			var randomTime = randf() * 2.5 + 0.4
			if not randomTimerStarted:
				print(randomTime)
				$randomTimer.set_wait_time(randomTime)
				$randomTimer.start()
				randomTimerStarted = true
			handleMelee()

	else:
		enemy = null
		
#AI FUNCTION
func turn():
	if enemy != null:
		var target_rotation = global_position.direction_to(enemy.global_position).angle() + PI/2
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
	var forward = Vector2(1, 0).rotated(rotation + PI/2)
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
	if Input.is_action_pressed("shoot"):
		if not meleeCooldown:
			handleMelee()
	if Input.is_action_just_released("shoot"):
		if not meleeCooldown:
			handleMeleeTiming()
		
	regenerateHealth()
	Global.health = health
	get_input()
	if ai_array.size() != 0:
		select_ai()
	else:
		closest_ai = null
		Global.closest_ai = closest_ai
	
	$Camera2D.current = true
#PLAYER FUNCTION
func get_input():
	rotation = get_global_mouse_position().angle_to_point(position) + 89.5
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
	velocity = move_and_slide(velocity)
	
	#Animations
	if input_direction and not drinkingPerk and not melee:
		if reverse:
			$AnimatedSprite.play("WalkReverse")
		else:
			$AnimatedSprite.play("Walk")
	elif not drinkingPerk and not melee:
		if reverse:
			$AnimatedSprite.play("IdleReverse")
		else:
			$AnimatedSprite.play("Idle")

func handleMeleeTiming():
		attackTime = time
		if attackTime < lightAttackTime:
			lightAttack()
		elif attackTime > heavyAttackStageOne:
			print("heavy attack")
			heavyAttack()

func handleMelee():
		stopped = false
		melee = true
		if not timeReset:
			time = 0
			timeReset = true
		if not stopped and not playing:
			playing = true
			if reverse:
				$AnimatedSprite.play("chargeReverse")
				animationPlayer.play("chargeReverse")
			else:
				$AnimatedSprite.play("charge")
				animationPlayer.play("charge")
		if time > heavyAttackStageOne:
			meleeMultiplier = 1.2
			amountOfKnockback = current_weapon.knockback * 1.2
			particles = MeleeParticles.instance()
			get_tree().current_scene.add_child(particles)
			particles.global_position = global_position
			particles.emitting = true
		if time > heavyAttackStageTwo:
			meleeMultiplier = 1.5
			amountOfKnockback = current_weapon.knockback * 1.5
			particles.queue_free()
			particlesTwo = MeleeParticlesTwo.instance()
			get_tree().current_scene.add_child(particlesTwo)
			particlesTwo.global_position = global_position
			particlesTwo.emitting = true
		if time > heavyAttackStageThree:
			meleeMultiplier = 1.6
			amountOfKnockback = current_weapon.knockback * 1.6
			particlesTwo.queue_free()
			particlesThree = MeleeParticlesThree.instance()
			get_tree().current_scene.add_child(particlesThree)
			particlesThree.global_position = global_position
			particlesThree.emitting = true
		if time > heavyAttackStageFour:
			meleeMultiplier = 2.5
			amountOfKnockback = current_weapon.knockback * 3
			particlesTwo = MeleeParticlesTwo.instance()
			get_tree().current_scene.add_child(particlesTwo)
			particlesTwo.global_position = global_position
			particlesTwo.emitting = true
			particles = MeleeParticles.instance()
			get_tree().current_scene.add_child(particles)
			particles.global_position = global_position
			particles.emitting = true
		print("Time : " + str(time))
		if time > 2:
			$AnimatedSprite.stop()
			animationPlayer.stop()
			stopped = true

func heavyAttack():
	stopped = false
	timeReset = false
	playing = false
	melee = true
	meleeCooldown = true
	if reverse:
		$AnimatedSprite.play("chargeHitReverse")
		animationPlayer.play("chargeHitReverse")
	else:
		$AnimatedSprite.play("chargeHit")
		animationPlayer.play("chargeHit")
	$Melee.start()
	$MeleeCooldown.start()
	meleeDamage = current_weapon.melee_damage * meleeMultiplier
	
func lightAttack():
	stopped = false
	timeReset = false
	playing = false
	melee = true
	meleeCooldown = true
	if reverse:
		$AnimatedSprite.play("HitReverse")
		animationPlayer.play("HitReverse")
	else:
		$AnimatedSprite.play("Hit")
		animationPlayer.play("Hit")
	$Melee.start()
	$MeleeCooldown.start()
	meleeDamage=current_weapon.melee_damage


#Character die if health <= 0
func damage(damage):
	health -= damage
	$hit.play()
	if not AI:
		Global.health = health
	if health <= 0 and not downed:
		downed()


#PLAYER FUNCTION
func select_ai():
	var closest_ai_distance = 99999999
	for a in ai_array:
		var distance = global_position.distance_to(a.global_position)
		if distance < closest_ai_distance:
			closest_ai = a
			closest_ai_distance = distance
	Global.closest_ai = closest_ai


#PLAYER FUNCTION
func regenerateHealth():
	if health < max_health:
		if juggerJuice:
			health +=0.2
		else:
			health += 0.1


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
		
		if playerAlive.get_ai_name() != "FreeRoamCamera" and playerAlive.get_ai_name() != "George" and playerAlive.health > 0:
			Global.current_player = playerAlive
			Global.refresh_ai()
			return
	get_tree().change_scene("res://UI/Game_Over.tscn")

func revived():
	self.add_to_group("AI")
	self.add_to_group("Player")
	downed = false
	speed = 400
	health = max_health
	$AnimatedSprite.speed_scale = 1


#PLAYER FUNCTION
func _on_closestAI_body_entered(body):
	if body.is_in_group("AI") and body != self:
		ai_array.append(body)


#PLAYER FUNCTION
func _on_closestAI_body_exited(body):
	if body.is_in_group("AI"):
		ai_array.erase(body)


func _on_downed_body_entered(body):
	if body.is_in_group("AI") and body != self and downed:
		downedArea.append(body)
		Global.player_in_downed_area = downedArea.size() != 0

func _on_downed_body_exited(body):
	if body.is_in_group("AI") and body != self and downed:
		downedArea.erase(body)
		Global.player_in_downed_area = downedArea.size() != 0


func fire_damage(dmg):
	health -= dmg
	if not AI:
		Global.health = health
	if health <= 0 and not downed:
		downed()
	$AnimatedSprite.modulate = Color("ff291f")
	$fireManager/fireDamage.start()
	$fireManager/playerFire.play()



func _on_Fire_timeout():
	fire_damage(15)
	fireTime -= 1
	if not fireTime <= 0:
		$fireManager/Fire.start()
	else:
		$fireManager/fireSound.playing = false
		onFire = false
		if is_instance_valid(fire):
			fire.queue_free()


func _on_fireDamage_timeout():
	$AnimatedSprite.modulate = Color("ffffff")
	$fireManager/fireDamage.stop()


func _on_Swift_Swig_perkUsed(perk):
	drinkingPerk = true
	$AnimatedSprite.play("swiftSwig")
	$drinkingPerk.play()
	$Perk.start()
	Perk = perk

func _on_Jugger_Juice_perkUsed(perk):
	drinkingPerk = true
	$AnimatedSprite.play("swiftSwig")
	$drinkingPerk.play()
	$Perk.start()
	Perk = perk

func _on_Perk_timeout():
	drinkingPerk = false
	if Perk.getPerkName() == "JuggerJuice":
		max_health = 130
		juggerJuice = true
		Global.juggerJuice = true
	elif Perk.getPerkName() == "SwiftSwig":
		swiftSwig = true
		Global.swiftSwig = true
	



func _on_Melee_timeout():
	melee = false
	reverse = !reverse


func _on_melee_body_entered(body):
	if body.is_in_group("Enemy"):
		body.meleeDamage(meleeDamage,amountOfKnockback)


func _on_MeleeCooldown_timeout():
	meleeCooldown = false


func _on_randomTimer_timeout():
	handleMeleeTiming()
	randomTimerStarted = false


func _on_George_on_fire(time):
	if not onFire:
		fireTime = time
		$fireManager/Fire.start()
		fire = Global.instance_node(Fire,$fireManager/fire.global_position,self)
		$fireManager/fireSound.playing = true
		onFire = true
