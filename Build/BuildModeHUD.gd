extends Control


func _ready():
	hide()
func _process(delta):
	if Global.build_mode:
		show()
	else:
		hide()
