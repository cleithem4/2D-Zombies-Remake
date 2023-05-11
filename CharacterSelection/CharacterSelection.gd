extends Node2D

var current_player = null

func _ready():
	set_process_input(true)

func _input(event):
	if Global.freeroam and event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		var click_position = get_global_mouse_position()
		var all_objects = get_tree().get_nodes_in_group("AI")
	
		for obj in all_objects:
			var distance = click_position.distance_to(obj.position)
			if distance <= 20: # 63 is the radius of the circle
				Global.freeroam_selected_player = obj
				Global.current_player = obj
				Global.refresh_ai()
				Global.freeroam = false
