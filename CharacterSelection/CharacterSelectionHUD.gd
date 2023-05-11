extends Control


func _ready():
	hide()
	
func _physics_process(delta):
	if Global.freeroam:
		show()
	else:
		hide()
