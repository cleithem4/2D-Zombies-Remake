extends Control


onready var Door = get_node("/root/GameScene/Door_container/Door")

func _ready():
	hide()

func _physics_process(_delta):
	if Global.player_in_door_area:
		if Global.door != null:
			$openDoor.text = Global.door.getButtonText()
			show()
	else:
		hide()


func _on_openDoor_pressed():
	if Global.door !=null:
		if Global.score > Global.door.getDoorPrice()-1:
			if Global.door !=null:
				Global.score -= Global.door.getDoorPrice()
				Global.door.open()

		
