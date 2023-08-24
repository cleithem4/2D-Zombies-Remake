extends Control


func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	hide()




	


func _on_Back_pressed():
	hide()
	get_parent().get_parent().Paused.show()
