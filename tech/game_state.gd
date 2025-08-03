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
		#Level.Create("res://levels/levels/TestLevel.tscn","Test level"),
		Level.Create("res://levels/levels/Level1.tscn", "Can you loop the UFO?"),
		Level.Create("res://levels/levels/Level2.tscn", "Can you loop two?"),
		Level.Create("res://levels/levels/Level_1_low.tscn", "Precision flying required"),
		Level.Create("res://levels/levels/Level_path_follow_0.tscn", "They're evolving...."),
		Level.Create("res://levels/levels/Level_path_follow_1.tscn", "Loops!"),
		Level.Create("res://levels/levels/Level_2path_follow_1.tscn", "Double trouble - broken :("),
		Level.Create("res://levels/levels/Level_3path_follow_1.tscn", "Triple trouble? - broken :("),
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
			
		

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file("res://menus/main_menu.tscn")
