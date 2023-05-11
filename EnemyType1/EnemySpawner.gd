extends Node2D

onready var zombie_scene = load("res://EnemyType1/EnemyType1.tscn")
onready var player = get_node_or_null("/root/GameScene/CharacterSelection/Player")

const MAX_ZOMBIES_SPAWNED = 10
const ZOMBIE_HEALTH = 10
const ZOMBIE_SPEED = 120
const MAX_ZOMBIE_SPEED = 280
const MIN_ZOMBIE_SPEED = 100

var current_zombie_health = 0
var current_zombie_speed = 0



var amount_of_zombies_on_current_wave = 10

var wave_number = 1
var zombies_spawned = 0
var zombies_killed = 0
var able_to_spawn = true
var able_to_start_wave = false

func _ready():
	print(player.get_path())
	randomize()



func spawn_wave():
	if zombies_spawned < amount_of_zombies_on_current_wave and able_to_spawn:
		spawn_zombie()


func start_wave():
	if able_to_start_wave:
		spawn_wave()
func on_zombie_killed():
	zombies_killed += 1
	if zombies_killed == amount_of_zombies_on_current_wave:
		wave_number += 1
		Global.wave = wave_number
		calculateAmountOfZombies()
		print("Amount of zombies on this wave: " + str(amount_of_zombies_on_current_wave))
		zombies_spawned = 0
		zombies_killed = 0
		able_to_start_wave = false
		$WaveCooldown.start()


func spawn_zombie():
	player = Global.current_player
	if player == null:
		print("Player node not found in the scene tree.")
		return
	var player_pos = player.global_position
	var radius = 1000
	var min_distance = 700  # Minimum spawn distance from the player
	var angle = rand_range(0, 2 * PI)
	var offset = Vector2(cos(angle), sin(angle)) * rand_range(min_distance, radius)
	var zombie_pos = player_pos + offset
	
	var zombie = zombie_scene.instance()
	var zombie_transform = Transform2D(0, zombie_pos)
	zombie.set_transform(zombie_transform)
	zombie.scale = Vector2(2,2)
	zombie.speed = 100

	var collision_shape = zombie.find_node("CollisionShape2D")
	if not collision_shape:
		print("Zombie does not have a CollisionShape2D node")
		return

	var collision = check_collision(collision_shape.shape, zombie_transform)

	if collision:
		print("Zombie spawn point inside wall, retrying...")
		spawn_zombie()
		return
	get_zombie_stats()
	zombie.speed = current_zombie_speed
	zombie.health = current_zombie_health
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

func get_zombie_stats():
	current_zombie_health = ZOMBIE_HEALTH + Global.wave
	current_zombie_speed = rand_range(MIN_ZOMBIE_SPEED,100 + Global.wave * 5)
	current_zombie_speed = min(current_zombie_speed,MAX_ZOMBIE_SPEED)

func _on_SpawnCooldown_timeout():
	able_to_spawn = true
	$SpawnCooldown.stop()
	spawn_wave()


func _on_WaveCooldown_timeout():
	able_to_start_wave = true
	$WaveCooldown.stop()
	start_wave()
