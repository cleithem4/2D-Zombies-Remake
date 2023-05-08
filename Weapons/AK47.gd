extends Node2D

var current_clip = 30
var clip_size = 30
var ROF = true
var reloading = false

onready var Bullet = load("res://Bullet/Bullet.tscn")
onready var end_of_gun = $end_of_gun

func _ready():
	pass
	

func _physics_process(delta):
	if current_clip < 1 and not reloading:
		reload()
func reload():
	if not clip_size == current_clip:
		reloading = true
		get_parent().get_parent().reloading()
		$Reload.start()

func _on_Reload_timeout():
	reloading = false
	current_clip = clip_size
	$Reload.stop()
	get_parent().get_parent().finished_reloading()
	
	
func shoot():
	if reloading:
		return
	if not ROF:
		return
	current_clip -= 1
	if current_clip < 1:
		reload()
		
	var bullet = Bullet.instance()
	var enemy = get_parent().get_parent().enemy
	var target = Vector2(0,0)
	if enemy!=null:
		target = get_parent().get_parent().enemy.global_position
	bullet.global_position = global_position
	var direction_to_mouse = end_of_gun.global_position.direction_to(target)
	bullet.set_direction(direction_to_mouse)
	bullet.global_rotation = direction_to_mouse.angle() + 12345
	get_tree().get_current_scene().add_child(bullet)
	ROF = false
	$ROF.start()
	$AudioStreamPlayer.play()


func _on_ROF_timeout():
	$ROF.stop()
	ROF = true
