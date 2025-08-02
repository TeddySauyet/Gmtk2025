extends CharacterBody2D
class_name Player


func _ready() -> void:
	SignalBus.player_died.connect(kill)
	
func kill() -> void:
	queue_free()

func duplicate_copy_main(main : Player) -> void:
	var rect := get_viewport_rect()
	if global_position.x < 0:
		global_position.x = main.global_position.x - rect.size.x
	else:
		global_position.x = main.global_position.x + rect.size.x
	velocity = main.velocity

func _physics_process(delta: float) -> void:
	if not is_in_group("main"):
		return
	var collision := get_last_slide_collision()
	if collision:
		#print_debug(collision.get_collider())
		#died.emit()
		SignalBus.player_died.emit()
