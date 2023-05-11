extends Node2D

var wave
func _ready():
	pass
func set_value_and_animate(val):
	wave = val
	$wave.text = str(val)
	$AnimationPlayer.play("waveFadeIn")

func _on_animation_finished_timeout():
	$AnimationPlayer.play("waveAnimation")
	$wave.text = str(wave+1)
