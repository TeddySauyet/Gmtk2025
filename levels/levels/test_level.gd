extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$LevelHelper.start_level()
	$LevelHelper.all_enemies_died.connect(victory)



func victory() -> void:
	print_debug("You win!")

func defeat() -> void:
	print_debug("You lose :()")
