extends Node2D

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var gpu_particles_2d2: GPUParticles2D = $GPUParticles2D2

signal finished()

func _ready() -> void:
	gpu_particles_2d.restart()
	gpu_particles_2d2.restart()
	$Timer.timeout.connect(kill)
	Sounds.explosion.play()


func kill() -> void:
	finished.emit()
	queue_free()
