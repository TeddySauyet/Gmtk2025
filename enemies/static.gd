extends CharacterBody2D
class_name StaticEnemy

signal died(item: Node2D)

func got_looped() -> void:
	died.emit(self)
	queue_free()
