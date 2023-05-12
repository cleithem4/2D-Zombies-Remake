extends Control


onready var scoreNumber = preload("res://Particles/ScoreNumber2D.tscn")
onready var waveNumber = preload("res://Particles/WaveNumber2D.tscn")

var wave_numbers = []
var MAX_ALPHA = 1.0
var MIN_ALPHA = 0.0
func _physics_process(_delta):
	$Score.text = "$" + str(Global.score)
	$Clip.text = str(Global.current_clip) + "/" + str(Global.clip_size)



	# Calculate the new alpha value based on the player's health
	var alpha_value = MAX_ALPHA - (Global.health * 0.01)
	alpha_value = max(alpha_value, MIN_ALPHA)

	# Set the alpha value of the ColorRect
	$Blood.set_modulate(Color(1.0, 1.0, 1.0, alpha_value))
func update_score(s):
	Global.score += s
	var score_number = scoreNumber.instance()
	score_number.set_value_and_animate(s,Vector2(10,0))
	add_child(score_number)
func update_wave(w):
	$Wave.text = ""
	animate_wave(w)
func animate_wave(w):
	if wave_numbers.size() > 0:
		for wave in wave_numbers:
			wave.queue_free()
		wave_numbers.clear()
	var wave_number = waveNumber.instance()
	wave_number.set_value_and_animate(w)
	$Wave.add_child(wave_number)
	wave_numbers.append(wave_number)
	


