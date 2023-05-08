extends Control


func _ready():
	hide()
func _process(_delta):
	if Global.build_mode:
		show()
	else:
		hide()
