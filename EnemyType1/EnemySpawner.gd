extends Node2D

onready var Enemy = load("res://EnemyType1/EnemyType1.tscn")

func _on_Timer_timeout():
	var VP = get_viewport().size
	print(VP)
	var enemy_position = Vector2(rand_range(0,VP.x),rand_range(0,VP.y))
	Global.instance_node(Enemy,enemy_position,self)
