extends Control

var closest_ai


func _ready():
	hide()
func _physics_process(delta):
	closest_ai = Global.closest_ai
	if closest_ai != null:
		$switchWeapon.text = "Switch Weapon(" + closest_ai.name + ")"
		show()
	else:
		hide()


func _on_switchWeapon_pressed():
	#Finds the player, signals to switch guns
	if find_player()=="tom":
		Global.switch_weapon_tom = true
	elif find_player()=="jay":
		Global.switch_weapon_jay = true
		
	
	print("weapons switched")
	#Finds the closest ai, signals to switch guns
	if closest_ai.get_ai_name() == "Player":
		Global.switch_weapon_tom = true
	elif closest_ai.get_ai_name() == "Jay":
		Global.switch_weapon_jay = true


#Finds the current player node
func find_player():
	if not Global.tom_ai:
		return "tom"
	elif not Global.jay_ai:
		return "jay"
	else:
		return "No player found"
