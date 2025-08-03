extends Node2D
class_name TrailMarker

signal dead(marker : TrailMarker)
var idx : int = 0
@export var alpha := 0.0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.timeout.connect(kill)
	SignalBus.level_clear.connect(kill)
	$GPUParticles2D.emitting = true
	#$AnimationPlayer.play("new_animation")
	$GPUParticles2D.material.set_shader_parameter("alpha", alpha)
	
func kill() -> void:
	dead.emit(self)
	queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
