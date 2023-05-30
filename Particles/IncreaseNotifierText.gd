extends Node2D

var label = ""
var player = null
func _ready():
	$Label.text = label
	$AnimationPlayer.play("move_and_fade")

func _physics_process(_delta):
	$Label.text = label
	global_position = player.global_position - Vector2(50,20)
func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
