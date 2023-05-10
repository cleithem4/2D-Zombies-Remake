extends Node2D

func _process(_delta):
	if $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.play()
	if not Global.jay_ai and $CharacterSelection/Jay == null or not Global.tom_ai and $CharacterSelection/Player == null:
		$AudioStreamPlayer.stop()
		get_tree().change_scene("res://UI/Game_Over.tscn")

func _physics_process(_delta):
	pass
func build_mode():
	get_tree().paused = true
	
