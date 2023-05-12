extends Node2D

var wave
func _ready():
	pass
func set_value_and_animate(val):
	wave = val-1
	$wave.text = str(wave)
	$AnimationPlayer.play("waveFadeIn")


func _on_Timer_timeout():
	$AnimationPlayer.play("waveAnimation")
	$wave.text = str(wave+1)
	$Timer.stop()

