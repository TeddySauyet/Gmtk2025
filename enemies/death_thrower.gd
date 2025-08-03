extends Node
class_name death_thrower

@export var target : Node2D


var active = false
var velocity := Vector2(0,0)
var angular_vel := 0.0
var gravity := 250
var scale_percent := 0.8


func activate(vel : Vector2 = Vector2(100,-250), avel : float = 7*PI) -> void:
	active = true
	velocity = vel
	randomize()
	if randf() < 0.5:
		velocity.x *= -1
	angular_vel = avel
	Sounds.ufo.play()
	
func _physics_process(delta: float) -> void:
	if active:
		velocity += gravity*delta * Vector2.DOWN
		target.global_position += velocity * delta
		target.global_rotation += angular_vel * delta
		target.global_scale *= 0.99
