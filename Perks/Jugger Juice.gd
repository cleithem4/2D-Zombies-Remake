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
	return "Jugger Juice $2500"
func getDoorPrice():
	return 2500
func getPerkName():
	"JuggerJuice"
	
func open():
	emit_signal("perkUsed",self)
	$queueFreeTimer.start()


func _on_queueFreeTimer_timeout():
	queue_free()
