extends Control


onready var Door = get_node("/root/GameScene/Door_container/Door")

func _ready():
	hide()

func _physics_process(_delta):
	if Global.player_in_door_area:
		show()
	else:
		hide()


func _on_openDoor_pressed():
	if Global.score > 750:
		Door.open()
		Global.score -= 750
