extends KinematicBody2D

var health = 50
var enemy_array = []
var enemy = null

func _ready():
	pass

func _physics_process(delta):
	if enemy_array.size() != 0:
		select_enemy()
		turn()
	else:
		enemy = null

func _on_Range_body_entered(body):
	if body.is_in_group("Enemy"):
		enemy_array.append(body.get_parent().get_node("EnemySpawner/Enemy"))
		print("Enemy array: ", enemy_array)

func _on_Range_body_exited(body):
	if body.is_in_group("Enemy"):
		enemy_array.erase(body.get_parent())

func turn():
	if enemy != null:
		print("enemy.position:", enemy.position)
		$turretHead.look_at(enemy.global_position)

func select_enemy():
	var closest_distance = 99999999
	for e in enemy_array:
		var distance = global_position.distance_to(e.global_position)
		if distance < closest_distance:
			enemy = e
			closest_distance = distance
