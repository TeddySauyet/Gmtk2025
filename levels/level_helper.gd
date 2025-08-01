extends Node2D
class_name LevelHelper

@export var root : Node2D

func _ready() -> void:
	$Duplicator.root = root

func start_level() -> void:
	for child in root.get_children():
		if child is EnemySpawner:
			var enemy = child.enemy_to_spawn.instantiate()
			if enemy.has_method("set_spawner"):
				enemy.set_spawner(child)
			enemy.global_position = child.global_position
			enemy.add_to_group("main")
			enemy.add_to_group("loopable")
			root.add_child(enemy)
		if child is PlayerSpawner:
			var player = preload("res://player/player.tscn").instantiate()
			player.find_child("Trail").spawn_parent = root
			player.global_position = child.global_position
			player.add_to_group("main")
			#$Player/Trail.spawn_parent = self
			root.add_child(player)
