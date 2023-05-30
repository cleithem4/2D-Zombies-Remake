extends Node2D

onready var increaseNotifierText = load("res://Particles/IncreaseNotifierText.tscn")
var object = null
func _ready():
	pass


func _on_WeaponDamage_weaponDamage(damageModifier):
	Global.get_current_player()
	for player in Global.all_ai:
		print(player)
		if player.get_ai_name() != "FreeRoamCamera":
			object = Global.instance_node(increaseNotifierText,player.global_position,self)
			object.player = player
			object.label = "Weapon Damage +" + str(damageModifier) + "%"
