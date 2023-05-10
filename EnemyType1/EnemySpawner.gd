extends Node2D

onready var zombie_scene = load("res://EnemyType1/EnemyType1.tscn")
onready var player = get_node_or_null("/root/GameScene/Player")

const ZOMBIES_PER_WAVE = 10

var amount_of_zombies_on_current_wave = 10

var wave_number = 1
var zombies_spawned = 0
var zombies_killed = 0
var able_to_spawn = true
var able_to_start_wave = true

func _ready():
	print("Player at start:", player)
	spawn_wave()

func spawn_wave():
	if able_to_start_wave:
		able_to_start_wave = false
		$WaveCooldown.start()
		if zombies_spawned <= amount_of_zombies_on_current_wave and able_to_spawn:
			spawn_zombie()
			print("Zombies spawned: " + str(zombies_spawned))

func on_zombie_killed():
	zombies_killed += 1
	print("zombies killed: " + str(zombies_killed))
	if zombies_killed == amount_of_zombies_on_current_wave:
		wave_number += 1
		print("Wave: " + str(wave_number))
		calculateAmountOfZombies()
		print("Amount of zombies on this wave: " + str(amount_of_zombies_on_current_wave))
		zombies_spawned = 0
		zombies_killed = 0
		spawn_wave()

func spawn_zombie():
	if player == null:
		print("Player node not found in the scene tree.")
		return
	var player_pos = player.global_position
	var radius = 1000
	var min_distance = 400  # Minimum spawn distance from the player
	var angle = rand_range(0, 2 * PI)
	var offset = Vector2(cos(angle), sin(angle)) * rand_range(min_distance, radius)
	var zombie_pos = player_pos + offset
	
	var zombie = zombie_scene.instance()
	var zombie_transform = Transform2D(0, zombie_pos)
	zombie.set_transform(zombie_transform)
	zombie.scale = Vector2(2,2)

	var collision_shape = zombie.find_node("CollisionShape2D")
	if not collision_shape:
		print("Zombie does not have a CollisionShape2D node")
		return

	var collision = check_collision(collision_shape.shape, zombie_transform)

	if collision:
		print("Zombie spawn point inside wall, retrying...")
		spawn_zombie()
		return
	
	add_child(zombie)
	zombies_spawned += 1
	able_to_spawn = false
	$SpawnCooldown.start()

func check_collision(shape, transform):
	var space_state = get_world_2d().direct_space_state
	var shape_query_parameters = Physics2DShapeQueryParameters.new()
	shape_query_parameters.set_shape(shape)
	shape_query_parameters.set_transform(transform)  # Adjust this to match the layer you want to check for collisions
	shape_query_parameters.set_exclude([self])
	var result = space_state.intersect_shape(shape_query_parameters)
	return result.size() > 0


func calculateAmountOfZombies():
	amount_of_zombies_on_current_wave *= 1.05
	amount_of_zombies_on_current_wave = ceil(amount_of_zombies_on_current_wave)



func _on_SpawnCooldown_timeout():
	able_to_spawn = true
	$SpawnCooldown.stop()


func _on_WaveCooldown_timeout():
	able_to_start_wave = true
	$WaveCooldown.stop()
	spawn_wave()
