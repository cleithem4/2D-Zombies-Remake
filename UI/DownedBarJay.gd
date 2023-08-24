extends Node2D

onready var Progressbar = $ProgressBar
onready var player = get_parent()
const HOLD_TIME = 4.0
var hold_time = 0.0
var inJayDownedArea = false


func _ready():
	pass
func _physics_process(delta):
	global_rotation = 0
	if Input.is_action_pressed("revive") and inJayDownedArea:
		Progressbar.show()
		hold_time += delta
		Progressbar.value = hold_time / HOLD_TIME * 100
		if hold_time > HOLD_TIME:
			player.revived()
			hold_time = 0
			Progressbar.value = 0
	else:
		Progressbar.hide()
		hold_time = 0
		Progressbar.value = 0


func _on_Jay_playerEnteredDownedArea():
	inJayDownedArea = true


func _on_Jay_playerExitedDownedArea():
	inJayDownedArea = false
