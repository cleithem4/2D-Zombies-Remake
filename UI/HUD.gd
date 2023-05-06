extends Control


func _physics_process(_delta):
	$Health.text = "Health: " + str(Global.health)
	$Score.text = "Score: " + str(Global.score)
