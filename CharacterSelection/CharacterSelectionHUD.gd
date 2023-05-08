extends Control


func _ready():
	hide()
	
func _physics_process(delta):
	if Global.character_selection_mode:
		show()
	else:
		hide()
