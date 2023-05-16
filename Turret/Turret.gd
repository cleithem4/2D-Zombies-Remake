extends KinematicBody2D

onready var Bullet = preload("res://Turret/TurretBullet.tscn")
onready var front_of_turret = get_node("turretHead/front_of_turret")

var health = 50
var enemy_array = []
var enemy = null
var able_to_shoot = true
var delta2 = 0

func _ready():
	Global.turrets.append(self)

func _physics_process(delta):
	delta2 = delta
	if enemy_array.size() != 0:
		select_enemy()
		turn()
		if able_to_shoot:
			shoot()
		$turretHead.play("Targeted")
	else:
		if $turretHead.animation != "Idle":
			$turretHead.play("Idle")
		enemy = null

func _on_Range_body_entered(body):
	if body.is_in_group("Enemy"):
		enemy_array.append(body)

func _on_Range_body_exited(body):
	if body.is_in_group("Enemy"):
		enemy_array.erase(body)

func turn():
	if enemy != null:
		var target_rotation = global_position.direction_to(enemy.global_position).angle()
		$turretHead.rotation = move_toward($turretHead.rotation, target_rotation, 0.2)
		

func select_enemy():
	var closest_distance = 99999999
	for e in enemy_array:
		var distance = global_position.distance_to(e.global_position)
		if distance < closest_distance:
			enemy = e
			closest_distance = distance
func shoot():
	$AudioStreamPlayer.play()
	var bullet = Bullet.instance()
	var target = enemy.position
	bullet.rotation = target.angle_to_point(position)
	bullet.global_position = front_of_turret.global_position
	get_parent().add_child(bullet)
	able_to_shoot = false
	
func rotate_toward(location: Vector2):
	rotation = lerp(rotation,global_position.direction_to(location).angle(),0.1)

func damage(d):
	health -= d
	$ProgressBar.value = health
	if health < 1:
		Global.turrets.erase(self)
		queue_free()

func _on_ROF_timeout():
	able_to_shoot = true
