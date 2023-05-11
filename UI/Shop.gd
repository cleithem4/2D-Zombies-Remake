extends Control

onready var Turret = preload("res://Turret/Turret.tscn")
onready var Jay = preload("res://Jay/Jay.tscn")
onready var BuildMode = preload("res://Build/BuildModeTurret.tscn")

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	hide()



func _physics_process(_delta):
	if Input.is_action_just_pressed("Shop") and not Global.build_mode:
		Global.instance_node(BuildMode,Vector2(-1000,-1000),get_parent().get_parent())
		if visible:
			hide()
		else:
			show()
	if Input.is_action_just_pressed("character_selection"):
		Global.freeroam = true



func _on_turretButton_pressed():
	if Global.score > 1999:
		hide()
		Global.build_mode = true
		Global.object = Turret
		Global.score -= 2000
		$ChaChing.play()




func _on_bulletDamage_pressed():
	if Global.score > 1499:
		hide()
		Global.damageModifier += 1
		Global.score -= 1500
		$ChaChing.play()
