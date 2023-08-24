extends KinematicBody2D

export var speed = 200
var spawnedSpeed = 0
export var health = 10
onready var HUD = get_node("/root/GameScene/CanvasLayer/HUD")
var velocity = Vector2.ZERO
var attackDmg = 10
var score = 5
var able_to_attack = true
onready var Blood = load("res://Particles/Blood.tscn")
onready var HeadshotBlood = load("res://Particles/headshotBlood.tscn") 
onready var DeathBlood = load("res://Particles/deathBlood.tscn") 
onready var Fire = load("res://Particles/Fire.tscn")
onready var shaderDissolve = load("res://Assets/dissolve.tres")
var fire = null
onready var parent = get_parent()
var in_attack_range = []

var headshot = false
onready var ZombieSprite = $AnimatedSprite
onready var closest_player = null
var closest_player_distance = null
var player_distance = null
onready var pathfinding = $NavigationAgent2D
var nextPositionReady = true
var direction = Vector2.ZERO
var next_location = Vector2.ZERO
var enemies_in_repulsion_force = []
var currentKnockback = Vector2.ZERO
var totalKnockback = 0
var dead = false
var knockback = false
var knockbackForce = 0
var knockbackDirection = null
signal on_fire(time)
var fireTime = 0
var onFire = false

func _ready():
	
	$Moan.play()
	$"moan timer".wait_time = rand_range(4,15)
	findClosestPlayer()
	updatePath()
	$AnimatedSprite.play("Walk")
	closest_player = Global.current_player
	closest_player_distance = global_position.distance_to(closest_player.global_position)




#Process the game 
var frame_count = 0
var timer = 0.0
var update_interval = 10  # Update every 10 frames
var frame_count_rotation = 0
var update_interval_rotation = 4
func _physics_process(delta):
	if ZombieSprite.material !=null:
		timer+= delta
		ZombieSprite.material.set_shader_param("time", timer)
		var value = ZombieSprite.material.get_shader_param("time")
	frame_count += 1
	frame_count_rotation += 1
	if dead:
		return
	if frame_count >= update_interval:
		frame_count = 0
		# Update pathfinding and direction here
		if pathfinding.is_navigation_finished():
			return
		if closest_player == null or not is_instance_valid(closest_player):
			return
		updatePathFinding()
	if frame_count_rotation >= update_interval_rotation:
		frame_count_rotation = 0
		handleRotation()
		# Collision Avoidance
		repulsionForce()
		
	
	
	updateVelocity(delta)
	# Damage calculation
	if able_to_attack:
		for body in in_attack_range:
			if not body.getDowned():
				body.damage(attackDmg)
				$Bite.play()
				able_to_attack = false


func repulsionForce():
	var repulsion_force = Vector2.ZERO
	if enemies_in_repulsion_force.size() != 0:
		for zombie in enemies_in_repulsion_force:
			
			if zombie != self and zombie.global_position.distance_to(self.global_position) < 60:
				repulsion_force += (self.global_position - zombie.global_position).normalized() * 0.5
		#if global_position.distance_to(closest_player.global_position) < 60:
			#repulsion_force = Vector2.ZERO
			#repulsion_force += (self.global_position - closest_player.global_position).normalized()
		global_position += repulsion_force
		
		
func handleRotation():
	rotation = direction.angle()


func updateVelocity(delta):
	if not is_instance_valid(closest_player):
		return
	if global_position.distance_to(closest_player.global_position) > 62:
		direction = (next_location - global_position).normalized()
		velocity = direction * speed
		global_position += velocity * delta
	else:
		velocity = Vector2.ZERO
	if knockback:
		global_position += totalKnockback/10
		currentKnockback += totalKnockback/10
		if abs(currentKnockback.x) >= abs(totalKnockback.x) and abs(currentKnockback.y) >= abs(totalKnockback.y):
			knockback = false
			currentKnockback = Vector2.ZERO
			

func updatePathFinding():
	next_location = pathfinding.get_next_location()
	direction = global_position.direction_to(next_location)


func findClosestPlayer():
	closest_player = null
	closest_player_distance = null
	for player in get_tree().get_nodes_in_group("Player"):
		if player.getDowned():
			print(str(player) + " is downed")
			continue
		player_distance = global_position.distance_to(player.global_position)
		if not is_instance_valid(closest_player) or closest_player == null:
			closest_player = player
			closest_player_distance = global_position.distance_to(closest_player.global_position)
		if player_distance < closest_player_distance:
			closest_player = player
			closest_player_distance = player_distance



func updatePath():
	if closest_player != null and is_instance_valid(closest_player):
		pathfinding.set_target_location(closest_player.global_position)
	else:
		pathfinding.set_target_location(global_position)


func fire_damage(dmg):
	health -= dmg
	if health <= 0:
		HUD.update_score(30)
		parent.on_zombie_killed(self)
		queue_free()
	$AnimatedSprite.modulate = Color("ff291f")
	$fireManager/fireDamage.start()
	$fireManager/zombieFire.play()
	

#Zombie dies if health <= 0
func damage(dmg,is_headshot,direction,is_shotgun):
	if dead:
		return
	score = 5
	if is_headshot:
		health -= dmg * 2
		score *= 2
		$headshot.play()
	else:
		health -= dmg
		score = 5
		$NormalShot.play()
	if is_shotgun:
		score = score/2
	HUD.update_score(score)
	if health <= 0:
		HUD.update_score(30)
		parent.on_zombie_killed(self)
		dead = true
		collision_layer = 0
		collision_mask = 0
		$Head.collision_layer = 0
		$Head.collision_mask = 0
		if is_headshot:
			$death.start()
			$AnimatedSprite.play("headshot")
			var blood = HeadshotBlood.instance()
			get_tree().current_scene.add_child(blood)
			blood.global_position = $fireManager/fire.global_position
			return
		else:
			$AnimatedSprite.play("Idle")
			$death.start()
			var blood = DeathBlood.instance()
			get_tree().current_scene.add_child(blood)
			blood.global_position = $fireManager/fire.global_position
			timer = 0.5
			$AnimatedSprite.material = shaderDissolve
			
	#adds blood to zombie each time they get shot
	var blood = Blood.instance()
	get_tree().current_scene.add_child(blood)
	blood.global_position = global_position
	blood.global_rotation = direction.angle()
	

func meleeDamage(dmg, knockback):
	if dead:
		return
	HUD.update_score(10)
	# Apply damage to the enemy
	health -= dmg
	$AnimatedSprite.modulate = Color("ff6e6e")
	$damaged.start()
	self.knockback = true
	knockbackDirection = -1*global_position.direction_to(closest_player.global_position)
	knockbackForce = knockback
	totalKnockback = knockbackDirection * knockback
	totalKnockback.normalized()
	
	# Slow the enemy for 1 second
	spawnedSpeed = speed
	speed = speed/2
	$slow.start()
	
	# Check if the enemy is dead
	if health <= 0:
		HUD.update_score(30)
		parent.on_zombie_killed(self)
		dead = true
		collision_layer = 0
		collision_mask = 0
		$Head.collision_layer = 0
		$Head.collision_mask = 0
		$AnimatedSprite.play("Idle")
		$death.start()
		var blood = DeathBlood.instance()
		get_tree().current_scene.add_child(blood)
		blood.global_position = $fireManager/fire.global_position
		timer = 0.5
		$AnimatedSprite.material = shaderDissolve

	


func _on_AttackRange_body_entered(body):
	if body.has_method("damage") and body.is_in_group("Player"):
		in_attack_range.append(body)


func _on_AttackSpeed_timeout():
	able_to_attack = true


func _on_AttackRange_body_exited(body):
	if body.is_in_group("Player"):
		in_attack_range.erase(body)




func _on_NewPath_timeout():
	updatePath()


func _on_closestPlayer_timeout():
	findClosestPlayer()





func _on_moan_timer_timeout():
	$Moan.play()
	





func _on_repulsionForce_body_entered(body):
	if body.is_in_group("Enemy"):
		enemies_in_repulsion_force.append(body)


func _on_repulsionForce_body_exited(body):
	if body.is_in_group("Enemy"):
		enemies_in_repulsion_force.erase(body)


func _on_EnemyType1_on_fire(time):
	if not onFire:
		fireTime = time
		$fireManager/Fire.start()
		fire = Global.instance_node(Fire,$fireManager/fire.global_position,self)
		$fireManager/fireSound.playing = true
		onFire = true

	


func _on_Fire_timeout():
	fire_damage(1)
	fireTime -= 1
	if not fireTime <= 0:
		$fireManager/Fire.start()
	else:
		$fireManager/fireSound.playing = false
		onFire = false
		fire.queue_free()


func _on_fireDamage_timeout():
	$AnimatedSprite.modulate = Color("ffffff")
	$fireManager/fireDamage.stop()


func _on_death_timeout():
	queue_free()


func _on_damaged_timeout():
	$AnimatedSprite.modulate = Color("ffffff")
	$AnimatedSprite.modulate = Color("7eaaff")
	$slow.start()


func _on_slow_timeout():
	speed = spawnedSpeed
	$AnimatedSprite.modulate = Color("ffffff")
