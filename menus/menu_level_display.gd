extends MarginContainer

@onready var info: Label = $VBoxContainer/Info
@onready var play: Button = $VBoxContainer/Play

var level : _GameState.Level : set = set_level

func set_level(from_level : _GameState.Level) -> void:
	level = from_level
	if is_inside_tree():
		play.pressed.connect(play_level)
		play.text = level.name
		

func _ready() -> void:
	if level:
		set_level(level)

func play_level() -> void:
	GameState.current_level = level
	get_tree().change_scene_to_packed(level.scene)
