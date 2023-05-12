extends Node2D


var spread = 500
var height = 100
func _ready():
	pass
func set_value_and_animate(val,start_pos):
	print($ScorePopUp)
	$ScorePopUp.text = "+" + str(val)
	$AnimationPlayer.play("scorePopup")
	var tween = Tween.new()
	var end_pos = Vector2(rand_range(-spread, spread), -height) + start_pos
	var tween_length = $AnimationPlayer.get_animation("scorePopup").length
	
	tween.interpolate_property($ScorePopUp, "rect_position", start_pos, end_pos, tween_length, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	tween.start()
