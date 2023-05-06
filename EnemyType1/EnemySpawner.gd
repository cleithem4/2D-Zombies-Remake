extends Node2D

onready var Enemy = load("res://EnemyType1/EnemyType1.tscn")

func _on_Timer_timeout():
	var VP = get_viewport().size
	print(VP)
	var enemy = Enemy.instance()
	enemy.position = Vector2(rand_range(0,VP.x),rand_range(0,VP.y))
	add_child(enemy)
