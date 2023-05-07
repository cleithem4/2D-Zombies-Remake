extends KinematicBody2D

onready var Turret = preload("res://Turret/Turret.tscn")


var able_to_build = false
var objects_in_area_array = []
var draw_color = Color("00ffffff")
var build_radius = 63

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
func _process(delta):

	if Global.build_mode:
		show()
		position = get_global_mouse_position()
		update_objects_in_area_array()
		update_objects_in_area_array2()
		print(objects_in_area_array)
		if objects_in_area_array.size() == 0:
			able_to_build = true
			draw_color = Color("5209fa12")
		else:
			able_to_build = false
			draw_color = Color("45ff0000")
		update()

func _input(event):
	if event.is_action_pressed("build"):
		build_turret()
	if event.is_action_pressed("exit_build_mode"):
		get_tree().paused = false
		Global.build_mode = false
		


func _draw():
	draw_circle(Vector2(0,-10), build_radius, draw_color)
	

func build_turret():
	if able_to_build:
		able_to_build = false
		Global.build_mode = false
		hide()
		Global.instance_node(Turret,get_global_mouse_position(),get_parent())

#Ensure that turret is not able to be placed on players, turrets, or zombies
func update_objects_in_area_array():
	objects_in_area_array.clear()
	var all_objects = get_tree().get_nodes_in_group("Object")
	
	for obj in all_objects:
		var distance = position.distance_to(obj.position)
		if distance <= build_radius: # 63 is the radius of the circle
			objects_in_area_array.append(obj)

#the second update ensures there are no gaps where turret can be placed over the structures
#without this second update, it is possible to place turret over buildings
func update_objects_in_area_array2():
	for angle in range(0, 360, 10): # Adjust the angle step for accuracy (smaller values give more accurate results)
		var ray_dir = Vector2(cos(deg2rad(angle)), sin(deg2rad(angle)))
		var ray_start = position
		var ray_end = ray_start + ray_dir * 63 # 63 is the radius of the circle
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(ray_start, ray_end, [], 1)
		if result.size() > 0:
			var hit_body = result["collider"]
			if hit_body.is_in_group("Object") and !objects_in_area_array.has(hit_body):
				objects_in_area_array.append(hit_body)




