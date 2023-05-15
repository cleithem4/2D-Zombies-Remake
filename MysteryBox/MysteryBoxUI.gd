extends Control

onready var MysteryBox = get_node_or_null("/root/GameScene/MysteryBox")



func _ready():
	hide()

func _process(_delta):
	if Global.player_in_mystery_box_area:
		if Global.mystery_box_gun != null:
			$takeMysteryBoxWeapon.text = "Take Weapon (" + Global.mystery_box_gun.getGunName() + ")"
		else:
			$takeMysteryBoxWeapon.text = "Open Mystery Box"
		if not Global.buttonClicked:
			show()
		else:
			if Global.mystery_box_gun != null:
				Global.buttonClicked = false
			elif Global.mystery_box_gun_taken:
				Global.buttonClicked = false
			hide()
	else:
		hide()

func _on_takeMysteryBoxWeapon_pressed():
	if Global.score > 0:
		if Global.mystery_box_gun == null:
			MysteryBox.open()
			Global.buttonClicked = true
		else:
			Global.mystery_box_gun_taken = true
			Global.buttonClicked = true
			MysteryBox.finishUpAndClose()
		Global.score -= 0
