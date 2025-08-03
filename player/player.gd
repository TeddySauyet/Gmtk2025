extends CharacterBody2D
class_name Player


var max_volume := -10.0
var min_volume := -30.0
var wind_delta := 10.0
var max_vol_speed := 600.0
var min_vol_speed := 0.0

func _ready() -> void:
	#SignalBus.player_died.connect(kill)
	start_heli()
	Sounds.helicopter.finished.connect(start_heli)
	start_wind()
	Sounds.wind.finished.connect(start_wind)
	
func start_heli() -> void:
	Sounds.helicopter.play()
func start_wind() -> void:
	Sounds.wind.play()

func kill() -> void:
	#if is_instance_valid($Sprite2D) and is_instance_valid($MovementInput) and is_instance_valid($CollisionShape2D):
		#$Sprite2D.visible = false
		#$MovementInput.queue_free()
		#$CollisionShape2D.queue_free()
		#var explosion := preload("res://player/explosion.tscn").instantiate()
		#explosion.finished.connect(kill_for_real)
		#add_child(explosion)
		#Sounds.helicopter.stop()
		#Sounds.wind.stop()
	#else:
	Sounds.helicopter.stop()
	Sounds.wind.stop()
	kill_for_real()
	
func kill_for_real() -> void:
	SignalBus.player_died.emit()
	queue_free()

func duplicate_copy_main(main : Player) -> void:
	var rect := get_viewport_rect()
	if global_position.x < 0:
		global_position.x = main.global_position.x - rect.size.x
	else:
		global_position.x = main.global_position.x + rect.size.x
	velocity = main.velocity

func _physics_process(delta: float) -> void:
	if global_position.y > 0:
		$Arrow.visible = false
	else:
		$Arrow.visible = true
		$Arrow.global_position.y = 20
		$Arrow.global_position.x = global_position.x
		$Arrow.global_rotation = 0
	if not is_in_group("main"):
		return
	var collision := get_last_slide_collision()
	if collision and collision.get_collider().is_in_group("main"):
		#print_debug(collision.get_collider())
		#died.emit()
		#SignalBus.player_died.emit()
		kill()
	var weight := clampf(velocity.length(), min_vol_speed, max_vol_speed)
	weight /= (max_vol_speed - min_vol_speed) 
	#print_debug(weight)
	if not Sounds.helicopter.playing:
		Sounds.helicopter.play()
	if not Sounds.wind.playing:
		Sounds.wind.play()
	Sounds.helicopter.volume_db = lerp(min_volume, max_volume, weight)
	Sounds.wind.volume_db = lerp(min_volume + wind_delta, max_volume + wind_delta, weight)
	
