extends Control

var MAX_ALPHA = 1.0
var MIN_ALPHA = 0.0
func _physics_process(_delta):
	$Score.text = "$" + str(Global.score)
	$Clip.text = str(Global.current_clip) + "/" + str(Global.clip_size)
	$Wave.text = "Wave: " + str(Global.wave)



	# Calculate the new alpha value based on the player's health
	var alpha_value = MAX_ALPHA - (Global.health * 0.01)
	alpha_value = max(alpha_value, MIN_ALPHA)

	# Set the alpha value of the ColorRect
	$Blood.set_modulate(Color(1.0, 1.0, 1.0, alpha_value))
