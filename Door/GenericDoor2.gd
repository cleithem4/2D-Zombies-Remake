extends KinematicBody2D

var inArea = []

func _ready():
	pass

func _on_Area2D_body_entered(body):
	if body.is_in_group("AI"):
		inArea.append(body)
		Global.player_in_door_area = inArea.size() != 0
		if inArea.size() != 0:
			Global.door = self


func _on_Area2D_body_exited(body):
	if body.is_in_group("AI"):
		inArea.erase(body)
		Global.player_in_door_area = inArea.size() != 0
		Global.door = null

func getButtonText():
	return "Open Door ($1250)"
func getDoorPrice():
	return 1250
func open():
	queue_free()
