extends Node2D

onready var current_weapon = $Pistol
onready var AK47 = load("res://Weapons/AK47.tscn")
onready var PISTOL = load("res://Weapons/Pistol.tscn")
onready var RPD = load("res://Weapons/RPD.tscn")
onready var CUSTOM = load("res://Weapons/Custom_SMG.tscn")
onready var RAYGUN = load("res://Weapons/RayGun.tscn")

var new_gun
var weapon_being_switched
var weapons = []
var weapon_being_switched_clip = 0


var parent = null
var pistol_position = Vector2(15,9)
var ak_position = Vector2(6,7)

var weapon_being_taken


func _ready():
	Global.tom_weapon = current_weapon
	weapons = get_children()
func _physics_process(delta):
	if Global.switch_weapon_tom:
		if Global.tom_ai:
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
		Global.tom_weapon = new_gun
		Global.tom_weapon.current_clip = weapon_being_switched_clip
		current_weapon = new_gun
		Global.switch_weapon_tom = false
		Global.temp_switch_guns_cleared = true
	if not Global.tom_ai:
		if Input.is_action_just_pressed("reload"):
			current_weapon.reload()
		if current_weapon.fullAuto():
			if Input.is_action_pressed("shoot"):
				current_weapon.shoot()
		else:
			if Input.is_action_just_pressed("shoot"):
				current_weapon.shoot()
	if Global.mystery_box_gun_taken:
		weapon_being_taken = get_instance_of_mystery_box_gun()
		new_gun = Global.instance_node(weapon_being_taken,global_position,self)
		current_weapon.queue_free()
		Global.tom_weapon = new_gun
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
func get_instance_of_mystery_box_gun():
	return returnWeaponInstance(Global.mystery_box_gun)
#Without this function, game will crash because the gun that is trying to be accessed is changed before
#The character switches his gun, resulting in both characters having the same gun. This script ensures 
#the guns are actually switched
func FindLostGun():
	var lostGun = null
	for gun in Global.temp_switch_guns:
		if is_instance_valid(gun):
			if current_weapon.getGunName() != gun.getGunName():
				lostGun = returnWeaponInstance(gun)
	if lostGun != null:
		new_gun = Global.instance_node(lostGun,global_position,self)

#Finds postion of gun for animations
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
	

