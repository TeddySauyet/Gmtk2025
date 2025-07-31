extends Node
class_name MovementInput

@export var char : CharacterBody2D

@export_category("Plane speeds")
@export var throttle_max : float = 600.0
@export var gravity_max : float = 500.0
@export var lift_max : float = 4000.0
@export var max_throttle_speed : float = 600
@onready var _drag_coef : float = throttle_max/max_throttle_speed**2

@export_category("Inputs")
@export var throttle_delta_scale : float = 1.0
var state_throttle_alpha := 1.0

#@onready var state_autopilot_angle := char.transform.get_rotation()
@onready var state_autopilot_angle := PI/4
var state_autopilot_on : bool = true
@export var lift_delta_scale := 1.0
var state_lift_alpha : float = 0.0

func _ready() -> void:
	char.velocity = Vector2(300.0,0)

func apply_movement(delta : float) -> void:
	var gravity_force := Vector2.DOWN * gravity_max
	
	var forward := char.global_transform.x
	var vertical := char.global_transform.y
	
	var vel2 = char.velocity.length_squared()
	var drag_force := Vector2.ZERO
	if vel2 != 0:
		drag_force = -char.velocity.normalized()*vel2*_drag_coef
	
	var throttle_force := forward * state_throttle_alpha * throttle_max
	
	
	
	var total_force := throttle_force + drag_force + gravity_force
	
	var lift_force := Vector2.ZERO
	if state_autopilot_on:
		#var des_dir := Vector2(cos(state_autopilot_angle), sin(state_autopilot_angle))
		#var des_force = -total_force.project(des_dir)
		#var len = des_force.length()
		#var max_mag_force = lift_max * char.velocity.length()/max_throttle_speed
		#var actual_mag = clampf(len, -max_mag_force, max_mag_force)
		#lift_force = vertical * actual_mag
		var scale := (vertical.project(Vector2.DOWN)).length()
		var mag := gravity_force.length()
		var max_force := lift_max * char.velocity.length()/max_throttle_speed
		mag = clampf(mag,-max_force,max_force)
		lift_force = vertical * mag
		
		
	else:
		lift_force = vertical * state_lift_alpha * lift_max * char.velocity.length()/max_throttle_speed
	
	print(total_force,lift_force)
	total_force += lift_force
	
	char.velocity += total_force * delta
	char.move_and_slide()
	char.rotation = char.velocity.angle()

func set_movement_values(delta : float) -> void:
	if Input.is_action_pressed("throttle"):
		state_throttle_alpha += throttle_delta_scale * delta
	if Input.is_action_pressed("flaps"):
		state_throttle_alpha -= throttle_delta_scale * delta
	state_throttle_alpha = clampf(state_throttle_alpha, -1, 1)
	state_lift_alpha += Input.get_axis("lift_up", "lift_down") * lift_delta_scale * delta
	state_lift_alpha = clampf(state_lift_alpha, -1.0, 1.0)
	var new_autopilot = Input.is_action_pressed("lift_down") or Input.is_action_pressed("lift_up")
	if new_autopilot != state_autopilot_on:
		state_autopilot_on
		if new_autopilot:
			state_autopilot_angle = char.velocity.angle()
			
	#if state_autopilot_on:
		#if char.velocity.angle() < state_autopilot_angle:
			#state_lift_alpha += lift_delta_scale*delta
		#elif char.velocity.angle() > state_autopilot_angle:
			#state_lift_alpha -= lift_delta_scale*delta
	
func _physics_process(delta: float) -> void:
	set_movement_values(delta)
	apply_movement(delta)
	#print(state_lift_alpha)
