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
	print(Global.turrets.size())
	print(Global.turrets)
	if Global.turrets.size() < 5:
		if Global.score > 2999:
			hide()
			Global.build_mode = true
			Global.object = Turret
			Global.score -= 3000
			$ChaChing.play()




func _on_bulletDamage_pressed():
	if Global.score > 4999:
		hide()
		Global.damageModifier += 0.45
		Global.score -= 5000
		$ChaChing.play()
