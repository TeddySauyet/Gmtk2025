extends CharacterBody2D
class_name Player


func duplicate_copy_main(main : Player) -> void:
	var rect := get_viewport_rect()
	if global_position.x < 0:
		global_position.x = main.global_position.x - rect.size.x
	else:
		global_position.x = main.global_position.x + rect.size.x
	velocity = main.velocity
