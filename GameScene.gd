extends Node2D

func _process(_delta):
	if $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.play()
	elif $Player == null:
		$AudioStreamPlayer.stop()
		get_tree().change_scene("res://UI/Game_Over.tscn")

func _physics_process(delta):
	pass
func build_mode():
	get_tree().paused = true
	
