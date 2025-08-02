extends Control

@onready var next: Button = $VBoxContainer/Next
@onready var main: Button = $VBoxContainer/main

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	next.pressed.connect(next_level)
	main.pressed.connect(main_menu)

func next_level() -> void:
	GameState.advance_level()
	
func main_menu() -> void:
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
