extends KinematicBody2D

var inArea = []
onready var animationPlayer = $AnimationPlayer
onready var JayInstance = load("res://Jay/Jay.tscn")
onready var characterSelection = get_node("/root/GameScene/CharacterSelection")
var actualJay

func _ready():
	pass


func open():
	actualJay = Global.instance_node(JayInstance,$Jay.global_position,characterSelection)
	animationPlayer.play("exitScreen")
	$Jay.queue_free()
	$"Help Me!".queue_free()
	actualJay.dialogue.show()
	$DialogueTimer.start()
	

func _on_Area2D_body_entered(body):
	if body.is_in_group("AI"):
		inArea.append(body)
		Global.player_in_door_area = inArea.size() != 0
		Global.door = self


func _on_Area2D_body_exited(body):
	if body.is_in_group("AI"):
		inArea.erase(body)
		Global.player_in_door_area = inArea.size() != 0
		Global.door = null

func getButtonText():
	return "Open Door ($750)"
func getDoorPrice():
	return 750


func _on_DialogueTimer_timeout():
	actualJay.dialogue.queue_free()
	queue_free()
