extends Node2D

var Jay
var Tom
var Freecam

func _ready():
	initialize_nodes()

func _process(_delta):
	if $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.play()
	if not Global.jay_ai and $CharacterSelection/Jay == null or not Global.tom_ai and $CharacterSelection/Player == null:
		$AudioStreamPlayer.stop()
		get_tree().change_scene("res://UI/Game_Over.tscn")
		
	

func _physics_process(_delta):
	pass
func build_mode():
	get_tree().paused = true

func initialize_nodes():
	Jay = get_node_or_null("/root/GameScene/CharacterSelection/Jay")
	Tom = get_node_or_null("/root/GameScene/CharacterSelection/Player")
	Freecam = get_node_or_null("/root/GameScene/CharacterSelection/FreeRoamCamera")
	#Starting player
	Global.current_player = Tom
	Global.all_ai = [Tom, Jay, Freecam]
