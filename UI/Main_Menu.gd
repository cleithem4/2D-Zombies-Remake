extends Control

func _on_Play_pressed():
	get_tree().change_scene("res://UI/Tutorial_Menu.tscn")

func _on_Quit_pressed():
	get_tree().quit()


func _on_Play_button_down():
	if $Play/AudioStreamPlayer.playing == false:
		$Play/AudioStreamPlayer.play()


func _on_Quit_button_down():
	if $Play/AudioStreamPlayer.playing == false:
		$Play/AudioStreamPlayer.play()
