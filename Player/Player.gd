extends KinematicBody2D

export var speed = 400
export var health = 100
var reloading = false
var velocity = Vector2()
onready var WeaponManager = $WeaponManager

func _ready():
	pass
#Get user input for player movement
func get_input():
	rotation = get_global_mouse_position().angle_to_point(position)
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
	#Animations
	if input_direction and not reloading:
		$AnimatedSprite.play("Walk")
	elif not reloading:
		$AnimatedSprite.play("Idle")
	elif reloading:
		$AnimatedSprite.play("Reload")
	




func reloading():
	reloading = true
func finished_reloading():
	reloading = false


#Process the game
func _physics_process(_delta):
	get_input()
	move_and_slide(velocity)

#Player die if health <= 0
func damage(damage):
	health -= damage
	Global.health = health
	if health <= 0:
		queue_free()



