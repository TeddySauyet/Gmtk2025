extends CharacterBody2D
class_name StaticEnemy

signal died(item: Node2D)

func got_looped() -> void:
	$DeathThrower.activate()
	$CollisionShape2D.queue_free()
	$Timer.timeout.connect(dead)
	$Timer.start()
	
	
	
func dead() -> void:
	died.emit(self)
	queue_free()
