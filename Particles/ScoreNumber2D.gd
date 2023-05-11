extends Node2D


func _ready():
	pass
func set_value_and_animate(val):
	$ScorePopUp.text = "+" + str(val)
	$AnimationPlayer.play("scorePopup")
