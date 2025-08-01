extends Node2D
class_name TrailMarker

signal dead(marker : TrailMarker)
var idx : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.timeout.connect(kill)

func kill() -> void:
	dead.emit(self)
	queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
