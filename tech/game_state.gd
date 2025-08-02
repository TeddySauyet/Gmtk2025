extends HBoxContainer
class_name _GameState


class Level:
	@export var scene: PackedScene
	@export var name : String
	var has_completed : bool = false
	var best_n_attempts : int = 0
	
	static func Create(path : String, name : String) -> Level:
		var level := Level.new()
		level.scene = load(path)
		level.name = name
		return level
		


var levels : Array[Level] = []
var current_level : Level

func _ready() -> void:
	levels = [
		Level.Create("res://levels/TestLevel.tscn","Test level"),
		Level.Create("res://levels/Level1.tscn", "Level 1")
	]

func advance_level() -> void:
	if not current_level:
		print_debug("no current level")
		current_level = levels[0]
		get_tree().change_scene_to_packed(current_level.scene)
	else:
		var idx := levels.find(current_level) + 1
		print_debug("changing to level ", idx)
		if idx > 0 and idx < levels.size():
			current_level = levels[idx]
			get_tree().change_scene_to_packed(current_level.scene)
		else:
			get_tree().change_scene_to_file("res://menus/main_menu.tscn")
			
		
