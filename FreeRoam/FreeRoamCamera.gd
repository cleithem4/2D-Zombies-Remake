extends KinematicBody2D

onready var player = get_node_or_null("/root/GameScene/CharacterSelection/Player")

var speed = 500
var AI = true
var velocity = Vector2.ZERO
var spawned = false


func getAI():
	return AI
func get_ai_name():
	return "FreeRoamCamera"


func _ready():
	pass
func _physics_process(delta):
	AI = Global.freeroam_camera_ai
	if Global.freeroam:
		Global.tom_ai = true
		Global.jay_ai = true
		AI = false
		$Camera2D.current = true
		if spawned:
			get_input()
			move_and_slide(velocity)
		else:
			position = Global.current_player.global_position
			spawned = true
	else:
		spawned = false



func get_input():
	rotation = get_global_mouse_position().angle_to_point(position)
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
