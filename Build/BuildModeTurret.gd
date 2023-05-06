extends KinematicBody2D

var able_to_build = false


var objects_in_area_array = []


func _ready():
	pass

func _process(delta):
	if Engine.paused:
		
		if Global.build_mode:
			position = get_global_mouse_position()
	
	
	if objects_in_area_array.size() == 0:
		able_to_build = true
	else:
		able_to_build = false

func _unhandled_input(event):
	if event.is_action_pressed("build"):
		verify_and_build_turret()

func _on_Area2D_area_entered(area):
	objects_in_area_array.append(area)

func _on_Area2D_area_exited(area):
	objects_in_area_array.erase(area)

func verify_and_build_turret():
	pass
