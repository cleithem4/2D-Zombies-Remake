extends Control



func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	hide()



func _physics_process(_delta):
	if Input.is_action_just_pressed("Shop"):
		if visible:
			hide()
			get_tree().paused = false
		else:
			show()
			get_tree().paused = true


func _on_turretButton_pressed():
	hide()
	Global.build_mode = true
