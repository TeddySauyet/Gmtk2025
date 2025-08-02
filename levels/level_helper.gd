extends Node2D
class_name LevelHelper

@export var root : Node2D

var victory := false

signal all_enemies_died()

var spawned_nodes : Array[Node]

var n_enemies := 0

func _ready() -> void:
	$Duplicator.root = root
	SignalBus.player_died.connect(on_player_died)

func start_level() -> void:
	for child in root.get_children():
		if child is EnemySpawner:
			var enemy = child.enemy_to_spawn.instantiate()
			if enemy.has_method("set_spawner"):
				enemy.set_spawner(child)
			enemy.global_position = child.global_position
			enemy.add_to_group("main")
			enemy.add_to_group("loopable")
			enemy.add_to_group("enemies")
			n_enemies += 1
			enemy.tree_exited.connect(enemy_exited_tree)
			root.add_child(enemy)
			spawned_nodes.push_back(enemy)
		if child is PlayerSpawner:
			var player = preload("res://player/player.tscn").instantiate()
			player.find_child("Trail").spawn_parent = root
			player.global_position = child.global_position
			player.add_to_group("main")
			root.add_child(player)
			spawned_nodes.push_back(player)

func clear_level() -> void:
	for child in root.get_children():
		if child in spawned_nodes:
			child.queue_free()
	spawned_nodes.clear() 
	SignalBus.level_clear.emit()
	
func enemy_exited_tree() -> void:
	n_enemies -= 1
	if n_enemies <= 0:
		#all_enemies_died.emit()
		victory = true
		var ui := preload("res://menus/level_complete.tscn").instantiate()
		ui.set_global_position(get_viewport_rect().size/2 - ui.get_rect().size/2)
		root.add_child(ui)

func on_player_died() -> void:
	if not victory:
		clear_level()
		start_level()
