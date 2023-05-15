extends Node2D

onready var AK47 = $guns/AK47
onready var RPD = $guns/RPD
onready var CUSTOM = $guns/CUSTOM
onready var RAYGUN = $guns/RAYGUN


var weapons_arr = ["AK47","RPD","CUSTOM","RAYGUN"]
var randomized_arr = []
var current_gun_showing = false
var timer = 0.0
var showTime = 0.7
var hideTime = 0.3
var opened = false
var showingGun = false
var currentGunIndex = 0
var AI = null

var InArea = []

var gunTimer = 8


func _ready():
	randomize()
	
func open():
	$AnimatedSprite.play("open")
	$boxOpen.start()
	
func _process(delta):
	if opened:
		if showingGun:
			timer += delta
			if timer >= showTime:
				hideGuns()
				showingGun = false
		else:
			timer += delta
			if timer >= hideTime:
				if currentGunIndex >= randomized_arr.size()-1:
					opened = false
					showingGun = false
					Global.mystery_box_gun = get_node("guns/" + randomized_arr[randomized_arr.size() - 1])
					Global.mystery_box_gun.show()
					Global.timerVisible = true
					$Timer.show()
					$gunDisappear.start()
					return
				else:
					show_next_gun()
	else:
		return
	
func randomGunOrder():
	randomized_arr.resize(weapons_arr.size()-4)
	for gun in weapons_arr:
		var size = randomized_arr.size()
		var index = randi() % (size + 1)
		randomized_arr.insert(index, gun)

func show_next_gun():
	# Show the next gun in the array
	var gun_node = get_node("guns/" + randomized_arr[currentGunIndex])
	gun_node.show()
	timer = 0.0
	showingGun = true
	currentGunIndex = currentGunIndex + 1

func hideGuns():
	for gun in randomized_arr:
		print(gun)
		var gun_node = get_node("guns/" + gun)
		gun_node.hide()
		timer = 0.0


func finishUpAndClose():
	$AnimatedSprite.play("close")
	hideGuns()
	Global.buttonClicked = false



func _on_Area2D_body_entered(body):
	if body.is_in_group("AI"):
		InArea.append(body)
		Global.player_in_mystery_box_area = InArea.size() != 0


func _on_Area2D_body_exited(body):
	if body.is_in_group("AI"):
		InArea.erase(body)
		Global.player_in_mystery_box_area = InArea.size() != 0


func _on_boxOpen_timeout():
	randomGunOrder()
	currentGunIndex = 0
	timer = 0.0
	opened = true
	$boxOpen.stop()


func _on_gunDisappear_timeout():
	gunTimer -= 1
	if gunTimer <= 0 or not Global.timerVisible:
		$Timer.hide()
		gunTimer = 8
		$gunDisappear.stop()
		Global.timerVisible = false
		finishUpAndClose()
		Global.mystery_box_gun = null
	$Timer.text = str(gunTimer)

