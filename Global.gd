extends Node




var health = 100
var score = 0
var wave = 1
var build_mode = false
var object = null
var current_clip = 0
var clip_size = 0


var jay_ai = true
var tom_ai = false
var freeroam_camera_ai = true
var freeroam = false
var all_ai = []
var freeroam_selected_player = null
var current_player = null

var switch_weapon_jay = false
var switch_weapon_tom = false
var temp_switch_guns_cleared = false
var closest_ai = null

var player_in_downed_area = false
var damageModifier = 1

var jay_weapon = null

var tom_weapon = null
var temp_switch_guns = []

var turrets = []

var starting_player_initialized = false


#MYSTERY BOX VARIABLES
var player_in_mystery_box_area = false
var mystery_box_gun = null
var mystery_box_gun_taken = false
var buttonClicked = false
var timerVisible = false



#DOOR VARIABLES
var player_in_door_area = false
var door = null


func _ready():
	pass


func _physics_process(delta):
	if not switch_weapon_jay and not switch_weapon_tom and not temp_switch_guns_cleared:
		temp_switch_guns.clear()
		temp_switch_guns_cleared = true

	
func instance_node(node,location,parent):
	var node_instance = node.instance()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance

func get_current_player():
	for p in all_ai:
		if not p.getAI():
			print("the player is " + p.get_ai_name())
			current_player = p
			return
func refresh_ai():
	if Global.current_player.get_ai_name()=="Tom":
		Global.tom_ai = false
		Global.jay_ai = true
		Global.freeroam_camera_ai = true
	elif Global.current_player.get_ai_name()=="Jay":
			Global.jay_ai = false
			Global.tom_ai = true
			Global.freeroam_camera_ai = true
func update_score(score):
	self.score += score

