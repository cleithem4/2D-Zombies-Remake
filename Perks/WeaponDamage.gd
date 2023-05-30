extends Node2D

var inArea = []
signal weaponDamage(damageModifier)
var cost = 0
var damageModifier = 0
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
	return "Weapon Damage $" + str(cost)
func getDoorPrice():
	return cost
	
func open():
	cost *= 2
	damageModifier += 0.25
	Global.damageModifier *= (1+damageModifier)
	emit_signal("weaponDamage",damageModifier * 100)
