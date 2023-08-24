extends Node2D

var current_clip = 6
var clip_size = 6
var ROF = true
var reloading = false
var melee_damage = 5
var knockback = 25
onready var Bullet = load("res://Bullet/ShotgunBullet.tscn")
onready var end_of_gun = $end_of_gun
onready var parent = get_parent().get_parent()
var bullet_count = 25 # number of bullets per shot
var spread = deg2rad(25) # spread in radians
var rng 

var AI
func _ready():
	rng = RandomNumberGenerator.new()
	AI = parent.AI
	
	


func fullAuto():
	return false
func getGunName():
	return "Pump-Shotgun"


func _physics_process(_delta):
	AI = parent.AI
	if not AI:
		Global.clip_size = clip_size
		Global.current_clip = current_clip
	if current_clip < 1 and not reloading:
		reload()
func reload():
	if not clip_size == current_clip:
		reloading = true
		parent.reloading()
		$Reload.wait_time = parent.reloadTime
		$Reload.start()

func _on_Reload_timeout():
	reloading = false
	current_clip = clip_size
	if not AI:
		Global.current_clip = current_clip
	$Reload.stop()
	parent.finished_reloading()
	
	
func shoot():
	if reloading:
		return
	if not ROF:
		return
	current_clip -= 1
	if current_clip < 1:
		reload()
	
	ROF = false
	$ROF.start()
	$muzzle_flash.show()
	$muzzle_flash.play("flash")
	$muzzleFlash.start()
		
	if not AI:
		$shot.play()
		$Pump.start()
		Global.current_clip = current_clip
		var bullet = Bullet.instance()
		var target = get_global_mouse_position()
		shoot_in_spread(target)
		
		
	
	#AI BULLET
	if AI:
		$shot.play()
		$Pump.start()
		var bullet = Bullet.instance()
		var enemy = parent.enemy
		var target = Vector2(0,0)
		if enemy!=null:
			target = parent.enemy.global_position
		else:
			return
		shoot_in_spread(target)


func _on_ROF_timeout():
	ROF = true
	$ROF.stop()


func _on_muzzleFlash_timeout():
	$muzzle_flash.hide()





func _on_Pump_timeout():
	$pump.play()


func shoot_in_spread(target):
	var base_direction = end_of_gun.global_position.direction_to(target)
	for i in range(bullet_count):
		rng.randomize()
		var spread_factor = rng.randf_range(-0.5, 0.5)
		var spread_direction = Vector2(base_direction.x * cos(spread * spread_factor) - base_direction.y * sin(spread * spread_factor), base_direction.x * sin(spread * spread_factor) + base_direction.y * cos(spread * spread_factor))
		var bullet = Bullet.instance()  # Define the bullet here
		bullet.global_position = end_of_gun.global_position
		bullet.set_direction(spread_direction)
		bullet.global_rotation = spread_direction.angle() + 12345
		get_tree().get_current_scene().add_child(bullet)
