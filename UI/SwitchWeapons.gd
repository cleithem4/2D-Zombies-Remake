extends Control

var closest_ai


func _ready():
	hide()
func _physics_process(_delta):
	closest_ai = Global.closest_ai
	if closest_ai != null:
		$switchWeapon.text = "Switch Weapon(" + closest_ai.get_ai_name() + ")"
		show()
	else:
		hide()


func _on_switchWeapon_pressed():
	#Finds the player, signals to switch guns
	if Global.current_player.get_ai_name()=="Tom":
		Global.switch_weapon_tom = true
	elif Global.current_player.get_ai_name()=="Jay":
		Global.switch_weapon_jay = true
	
	#Finds the closest ai, signals to switch guns
	if closest_ai != null:
		if Global.closest_ai.get_ai_name() == "Tom":
			Global.switch_weapon_tom = true
		elif Global.closest_ai.get_ai_name() == "Jay":
			Global.switch_weapon_jay = true
	else:
		Global.switch_weapon_tom = false
		Global.switch_weapon_jay = false



