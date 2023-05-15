extends Control


func _ready():
	hide()
	
func _physics_process(_delta):
	if Global.freeroam:
		show()
	else:
		hide()
