extends Node

var health = 100
var score = 0
var build_mode = false
var character_selection_mode = false
var object = null
var current_clip = 0
var clip_size = 0
var jay_ai = true
var tom_ai = false
var all_ai = [jay_ai,tom_ai]

var switch_weapon_jay = false
var switch_weapon_tom = false
var temp_switch_guns_cleared = false
var closest_ai = null


var jay_weapon = null

var tom_weapon = null
var temp_switch_guns = []


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
