extends Control


func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS



func _on_Resume_pressed():
	get_tree().paused = false	
	hide()


func _on_Quit_pressed():
	get_tree().quit()

func _physics_process(_delta):
	if Input.is_action_just_pressed("Pause"):
		if visible:
			hide()
			get_tree().paused = false
		else:
			show()
			get_tree().paused = true
