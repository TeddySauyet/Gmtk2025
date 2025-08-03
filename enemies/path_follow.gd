extends CharacterBody2D
class_name PathFollowEnemy

signal died(item: Node2D)

var speed := 10.0
var loop := false
var follow : PathFollow2D
var dir := 1.0
var rtrans : RemoteTransform2D

func got_looped() -> void:
	died.emit(self)
	queue_free()

func set_spawner(node : Node2D) -> void:
	if "speed" in node:
		speed = node.speed
	if "loop" in node:
		loop = node.loop
	for child in node.get_children():
		if child is Path2D:
			follow = PathFollow2D.new()
			child.add_child(follow)
			follow.loop = loop
			rtrans = RemoteTransform2D.new()
			rtrans.remote_path = get_path()
			child.add_child(rtrans)
			break

func _physics_process(delta: float) -> void:
	if follow:
		#print_debug('hiya')
		#print_debug(rtrans.remote_path, rtrans.global_position,follow.progress,follow.global_transform)
		follow.progress += delta * speed * dir
		if follow.get_progress_ratio() >= 1.0 or follow.get_progress_ratio() <= 0:
			print_debug('switch')
			dir *= -1.0
			follow.progress += delta*speed * dir
		global_position = follow.global_position
