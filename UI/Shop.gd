extends Control

onready var Turret = preload("res://Turret/Turret.tscn")
onready var Jay = preload("res://Jay/Jay.tscn")
onready var BuildMode = preload("res://Build/BuildModeTurret.tscn")

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	hide()



func _physics_process(_delta):
	if Input.is_action_just_pressed("Shop") and not Global.build_mode:
		Global.instance_node(BuildMode,Vector2(0,0),get_parent().get_parent())
		if visible:
			hide()
			get_tree().paused = false
		else:
			show()
			get_tree().paused = true


func _on_turretButton_pressed():
	if Global.score > 799:
		hide()
		Global.build_mode = true
		Global.object = Turret
		Global.score -= 800


func _on_JayButton_pressed():
	if Global.score > 1499:
		hide()
		Global.build_mode = true
		Global.object = Jay
		Global.score -= 1500
