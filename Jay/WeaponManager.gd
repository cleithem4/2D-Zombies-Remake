extends Node2D

onready var current_weapon = $AK47

var weapons = []
var parent = null


func _ready():
	weapons = get_children()
func _physics_process(delta):
	if Input.is_action_just_pressed("reload"):
		current_weapon.reload()
	if Input.is_action_just_pressed("shoot"):
		current_weapon.shoot()




	

