extends Node2D

onready var current_weapon = $AK47
onready var AK47 = load("res://Weapons/AK47.tscn")
onready var PISTOL = load("res://Weapons/Pistol.tscn")

var weapons = []
var parent = null
var weapon_being_switched
var new_gun
var pistol_position = Vector2(15,7)
var ak_position = Vector2(8,6)

func _ready():
	Global.jay_weapon = current_weapon
	weapons = get_children()
func _physics_process(delta):
	if Global.switch_weapon_jay:
		if Global.jay_ai:
			weapon_being_switched = get_instance_of_player_gun()
		else:
			weapon_being_switched = get_instance_of_ai_gun()
		new_gun = Global.instance_node(weapon_being_switched,global_position,self)
		Global.temp_switch_guns.append(current_weapon)
		if new_gun.getGunName() == current_weapon.getGunName():
			FindLostGun()
		current_weapon.queue_free()
		Global.jay_weapon = new_gun
		current_weapon = new_gun
		Global.switch_weapon_jay = false
		Global.temp_switch_guns_cleared = true
	findGunPosition()
	if not Global.jay_ai:
		if Input.is_action_just_pressed("reload"):
			current_weapon.reload()
	if current_weapon.fullAuto():
		if Input.is_action_pressed("shoot"):
			current_weapon.shoot()
	else:
		if Input.is_action_just_pressed("shoot"):
			current_weapon.shoot()
	refreshWeapons()



func shoot():
	current_weapon.shoot()
	
func get_instance_of_ai_gun():
	if Global.closest_ai.current_weapon.getGunName() == "Pistol":
		return PISTOL
	elif Global.closest_ai.current_weapon.getGunName() == "AK47":
		return AK47
func get_instance_of_player_gun():
	if not Global.tom_ai:
		print("Player is AI")
		if Global.tom_weapon.getGunName() == "Pistol":
			print("Player has pistol")
			return PISTOL
		if Global.tom_weapon.getGunName() == "AK47":
			print("Player has AK")
			return AK47
	elif not Global.jay_ai:
		if Global.jay_weapon.getGunName() == "Pistol":
			return PISTOL
		if Global.jay_weapon.getGunName() == "AK47":
			return AK47
			

func FindLostGun():

	var lostGun = null
	for gun in Global.temp_switch_guns:
		if is_instance_valid(gun):
			if current_weapon.getGunName() != gun.getGunName():
				if gun.getGunName() == "Pistol":
					lostGun = PISTOL
				elif gun.getGunName() == "AK47":
					lostGun = AK47
	if lostGun != null:
		new_gun = Global.instance_node(lostGun,global_position,self)
func findGunPosition():
	if current_weapon.getGunName() == "Pistol":
		position = pistol_position
	elif current_weapon.getGunName() == "AK47":
		position = ak_position
func refreshWeapons():
	weapons = get_children()
	for gun in weapons:
		if gun.getGunName() != current_weapon.getGunName():
			gun.queue_free()
			weapons.erase(gun)
