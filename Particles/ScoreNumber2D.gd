extends Node2D


var spread = 500
var height = 100
func _ready():
	pass
func set_value_and_animate(val,start_pos):

	$ScorePopUp.text = "+" + str(val)
	$AnimationPlayer.play("scorePopup")

