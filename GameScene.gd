extends Node2D

onready var Jay
onready var Tom
onready var Freecam
onready var George
onready var characterSelection
onready var Tutorial
onready var Paused
func _ready():
	initialize_nodes()

func _process(_delta):
	if $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.play()
	if not Global.jay_ai and $CharacterSelection/Jay == null or not Global.tom_ai and $CharacterSelection/Player == null:
		$AudioStreamPlayer.stop()
		get_tree().change_scene("res://UI/Game_Over.tscn")
	update_players()
	

func build_mode():
	get_tree().paused = true

func initialize_nodes():
	Jay = get_node_or_null("/root/GameScene/CharacterSelection/Jay")
	Tom = get_node_or_null("/root/GameScene/CharacterSelection/Player")
	Freecam = get_node_or_null("/root/GameScene/CharacterSelection/FreeRoamCamera")
	characterSelection = get_node_or_null("/root/GameScene/CharacterSelection")
	George = get_node_or_null("/root/GameScene/CharacterSelection/George")
	#Starting player
	Global.current_player = Tom
	Global.all_ai = [Tom, George, Freecam]
	Tutorial = $CanvasLayer/Tutorial
	Paused = $CanvasLayer/Pause
func update_players():
	Global.all_ai = characterSelection.get_children()
