extends Node2D

var inArea = []
signal perkUsed(perk)


func _ready():
	pass


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
	return "Swift Swig $2500"
func getDoorPrice():
	return 2500
	
func open():
	emit_signal("perkUsed",self)
