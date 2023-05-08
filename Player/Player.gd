extends KinematicBody2D

export var speed = 400
export var health = 100
var current_clip = 12
var clip_size = 12
var velocity = Vector2()
var reloading = false
onready var Bullet = load("res://Bullet/Bullet.tscn")

onready var end_of_gun = $end_of_gun
func _ready():
	Global.clip_size = clip_size
	Global.current_clip = current_clip
#Get user input for player movement
func get_input():
	rotation = get_global_mouse_position().angle_to_point(position)
	var input_direction = Input.get_vector("left", "right", "up", "down")

	if input_direction and not reloading:
		$AnimatedSprite.play("Walk")
		
	elif not reloading:
		$AnimatedSprite.play("Idle")
	velocity = input_direction * speed
	

func reload():
	reloading = true
	$AnimatedSprite.play("Reload")
	$Reload.start()


func shoot():
	if not reloading:
		if Input.is_action_just_pressed("shoot"):
			current_clip -= 1
			Global.current_clip = current_clip
			if current_clip < 1:
				reload()
		
			var bullet = Bullet.instance()
			var target = get_global_mouse_position()
			bullet.rotation = get_global_mouse_position().angle_to_point(position)
			bullet.global_position = end_of_gun.global_position
			bullet.rotation = rotation + 300
			get_parent().add_child(bullet)
			$AudioStreamPlayer.play()
		

#Process the game
func _physics_process(_delta):
	get_input()
	move_and_slide(velocity)
	shoot() #Get shoot function
	if Input.is_action_just_pressed("reload") and current_clip != clip_size:
		reload()

#Player die if health <= 0
func damage(damage):
	health -= damage
	Global.health = health
	if health <= 0:
		queue_free()


func _on_Reload_timeout():
	reloading = false
	current_clip = clip_size
	Global.current_clip = current_clip
	$Reload.stop()
