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


var switch_weapon_jay = false
var switch_weapon_tom = false
var closest_ai = null


var jay_weapon = null

var tom_weapon = null
var temp_switch_guns = []


func _ready():
	pass
func instance_node(node,location,parent):
	var node_instance = node.instance()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance
	
