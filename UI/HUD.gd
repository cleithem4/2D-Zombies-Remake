extends Control


func _physics_process(_delta):
	$Health.text = "Health: " + str(Global.health)
	$Score.text = "$" + str(Global.score)
	$Clip.text = str(Global.current_clip) + "/" + str(Global.clip_size)
