extends Control

@onready var level_options: GridContainer = $LevelOptions



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for level in GameState.levels:
		var scene := preload("res://menus/menu_level_display.tscn").instantiate()
		scene.level = level
		level_options.add_child(scene)
