extends Node2D

var current_clip = 30
var clip_size = 30
var reloading = false
onready var Bullet = load("res://Bullet/Bullet.tscn")
onready var end_of_gun = $end_of_gun

func _ready():
	Global.clip_size = clip_size
	Global.current_clip = current_clip
	

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
	Global.current_clip = current_clip
	$Reload.stop()
	get_parent().get_parent().finished_reloading()
func shoot():
	if reloading:
		return
	current_clip -= 1
	if current_clip < 1:
		reload()
		
	var bullet = Bullet.instance()
	var target = enemy.global_position
	bullet.global_position = end_of_gun.global_position
	var direction_to_mouse = end_of_gun.global_position.direction_to(target)
	bullet.set_direction(direction_to_mouse)
	bullet.global_rotation = direction_to_mouse.angle() + 12345
	get_tree().get_current_scene().add_child(bullet)
	ROF = false
	$ROF.start()


func _on_ROF_timeout():
	pass # Replace with function body.
