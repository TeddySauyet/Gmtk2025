extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = preload("res://player/player.tscn").instantiate()
	player.find_child("Trail").spawn_parent = self
	player.global_position = Vector2(200,200)
	player.add_to_group("main")
	#$Player/Trail.spawn_parent = self
	add_child(player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
