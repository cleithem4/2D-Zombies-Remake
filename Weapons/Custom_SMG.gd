extends Node2D

var current_clip = 24
var clip_size = 24
var ROF = true
var reloading = false
var melee_damage = 3
var knockback = 10
var AI
onready var Bullet = load("res://Bullet/PistolBullet.tscn")
onready var end_of_gun = $end_of_gun
onready var parent = get_parent().get_parent()
func _ready():
	AI = parent.AI
	
	


func fullAuto():
	return true
func getGunName():
	return "Custom SMG"


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
		$AudioStreamPlayer.play()
		Global.current_clip = current_clip
		var bullet = Bullet.instance()
		var target = get_global_mouse_position()
		bullet.global_position = end_of_gun.global_position
		var direction_to_mouse = end_of_gun.global_position.direction_to(target)
		bullet.set_direction(direction_to_mouse)
		bullet.global_rotation = direction_to_mouse.angle() + 12345
		get_tree().get_current_scene().add_child(bullet)
		
		
	
	#AI BULLET
	if AI:
		$AudioStreamPlayer.play()
		var bullet = Bullet.instance()
		var enemy = parent.enemy
		var target = Vector2(0,0)
		if enemy!=null:
			target = parent.enemy.global_position
		else:
			return
		bullet.global_position = end_of_gun.global_position
		var direction_to_mouse = end_of_gun.global_position.direction_to(target)
		bullet.set_direction(direction_to_mouse)
		bullet.global_rotation = direction_to_mouse.angle() + 12345
		get_tree().get_current_scene().add_child(bullet)
	


func _on_ROF_timeout():
	$ROF.stop()
	ROF = true


func _on_muzzleFlash_timeout():
	$muzzle_flash.hide()
