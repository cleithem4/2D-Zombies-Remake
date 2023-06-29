extends Node2D

onready var current_weapon = $Pistol
onready var AK47 = load("res://Weapons/AK47.tscn")
onready var PISTOL = load("res://Weapons/Pistol.tscn")
onready var RPD = load("res://Weapons/RPD.tscn")
onready var CUSTOM = load("res://Weapons/Custom_SMG.tscn")
onready var RAYGUN = load("res://Weapons/RayGun.tscn")
onready var M24 = load("res://Weapons/M24.tscn")
onready var PUMPSHOTGUN = load("res://Weapons/PumpAction.tscn")
var current_parent = get_parent()

var weapons = []
var weapon_being_switched_clip = 0
var parent = null
var weapon_being_switched
var new_gun
var pistol_position = Vector2(15,7)
var ak_position = Vector2(8,6)

var weapon_being_taken


func _ready():
	Global.jay_weapon = current_weapon
	weapons = get_children()
func _physics_process(_delta):

	if Global.switch_weapon_jay:
		if Global.jay_ai:
			weapon_being_switched = get_instance_of_player_gun()
			weapon_being_switched_clip = Global.current_player.current_weapon.current_clip
		else:
			weapon_being_switched = get_instance_of_ai_gun()
			weapon_being_switched_clip = Global.closest_ai.current_weapon.current_clip
		new_gun = Global.instance_node(weapon_being_switched,global_position,self)
		Global.temp_switch_guns.append(current_weapon)
		if new_gun.getGunName() == current_weapon.getGunName():
			FindLostGun()
		current_weapon.queue_free()
		Global.jay_weapon = new_gun
		Global.jay_weapon.current_clip = weapon_being_switched_clip
		current_weapon = new_gun
		Global.switch_weapon_jay = false
		Global.temp_switch_guns_cleared = true
	if not Global.jay_ai:
		current_parent = get_parent()
		if not current_parent.drinkingPerk and not current_parent.reloading:
			if Input.is_action_just_pressed("reload"):
				current_weapon.reload()
			if current_weapon.fullAuto():
				if Input.is_action_pressed("shoot"):
					current_weapon.shoot()
			else:
				if Input.is_action_just_pressed("shoot"):
					current_weapon.shoot()
	if Global.mystery_box_gun_taken and not Global.jay_ai:
		weapon_being_taken = get_instance_of_mystery_box_gun()
		new_gun = Global.instance_node(weapon_being_taken,global_position,self)
		current_weapon.queue_free()
		Global.jay_weapon = new_gun
		current_weapon = new_gun
		Global.timerVisible = false
		Global.current_player.current_weapon = new_gun
		Global.mystery_box_gun_taken = false
		Global.mystery_box_gun = null
	refreshWeapons()
	findGunPosition()

func shoot():
	current_weapon.shoot()
	
func get_instance_of_ai_gun():
	return returnWeaponInstance(Global.closest_ai.current_weapon)
func get_instance_of_player_gun():
	if not Global.tom_ai:
		return returnWeaponInstance(Global.tom_weapon)
	elif not Global.jay_ai:
		return returnWeaponInstance(Global.jay_weapon)
	elif not Global.george_ai:
		return returnWeaponInstance(Global.george_weapon)
func get_instance_of_mystery_box_gun():
	return returnWeaponInstance(Global.mystery_box_gun)
func FindLostGun():
	var lostGun = null
	for gun in Global.temp_switch_guns:
		if is_instance_valid(gun):
			if current_weapon.getGunName() != gun.getGunName():
				lostGun = returnWeaponInstance(gun)
	if lostGun != null:
		new_gun = Global.instance_node(lostGun,global_position,self)
func findGunPosition():
	if current_weapon.getGunName() == "Pistol":
		position = pistol_position
	elif current_weapon.getGunName() == "AK47":
		position = ak_position
	elif current_weapon.getGunName()=="RPD":
		position = ak_position
	elif current_weapon.getGunName() == "Custom SMG":
		position = pistol_position
	elif current_weapon.getGunName() == "Ray Gun":
		position = pistol_position
	elif current_weapon.getGunName() == "M24":
		position = ak_position
	elif current_weapon.getGunName() == "Pump-Shotgun":
		position = ak_position
func refreshWeapons():
	weapons = get_children()
	for gun in weapons:
		if gun.getGunName() != current_weapon.getGunName():
			gun.queue_free()
			weapons.erase(gun)

func returnWeaponInstance(weapon):
	if weapon.getGunName() == "Pistol":
		return PISTOL
	elif weapon.getGunName() == "AK47":
		return AK47
	elif weapon.getGunName() == "RPD":
		return RPD
	elif weapon.getGunName() == "Custom SMG":
		return CUSTOM
	elif weapon.getGunName() == "Ray Gun":
		return RAYGUN
	elif weapon.getGunName() == "M24":
		return M24
	elif weapon.getGunName() == "Pump-Shotgun":
		return PUMPSHOTGUN
