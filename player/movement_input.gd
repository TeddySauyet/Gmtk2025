extends Node
class_name MovementInput

@export var char : CharacterBody2D

@export_category("Plane speeds")
@export var speed_factor := 0.25
@export var throttle_max : float = 300.0
@export var gravity_max : float = 750.0
@export var lift_vel_coef := 800.0 #200.0
@export var max_throttle_speed : float = 600.0
@export var thin_air_threshold := 100.0
@export var thin_air_delta := 0.01
@export var flaps_max_force := 500
var state_in_thin_air := false : set = set_thin_air
@onready var _drag_coef : float = throttle_max/max_throttle_speed**2

@export_category("Inputs")
@export var throttle_delta_scale : float = 1.0
var state_throttle_alpha := 1.0
var state_flaps := false

var state_autopilot_on : bool = true
@export var lift_delta_scale := 5.0
var state_lift_alpha : float = 0.0

func _ready() -> void:
	char.velocity = Vector2(300.0,0)

## Only clamps magnitude without direction
func clamp_vec_mag(vec : Vector2, mini, maxi) -> Vector2:
	var mag = vec.length()
	if mag < mini:
		return vec.normalized() * mini
	elif mag > maxi:
		return vec.normalized() * maxi
	else:
		return vec

func apply_movement(delta : float) -> void:
	
	
	var thin_air := 1.0
	if char.global_position.y < thin_air_threshold:
		state_in_thin_air = true
		thin_air = clampf((thin_air_threshold - char.global_position.y )*thin_air_delta, 0.0, 1.0)
	
	var gravity_force := Vector2.DOWN * gravity_max
	
	var forward := char.global_transform.x
	var vertical := char.global_transform.y
	
	var vel2 = char.velocity.length_squared()
	var drag_force := Vector2.ZERO
	if vel2 != 0:
		drag_force = -char.velocity.normalized()*vel2*_drag_coef
	var throttle_force := forward * state_throttle_alpha * throttle_max * thin_air
	
	var flaps_force := Vector2.ZERO
	if state_flaps:
		flaps_force = -forward * flaps_max_force
	
	var total_force := throttle_force + drag_force + gravity_force + flaps_force
	total_force *= speed_factor
	
	var lift_force := Vector2.ZERO
	if state_autopilot_on:
		var max_vertical_force := vertical * char.velocity.length() * lift_vel_coef
		var max_up_portion := vertical.project(Vector2.UP).length() * max_vertical_force.length()
		var desired_up_portion := total_force.project(Vector2.UP).length()
		var frac = clampf(max_up_portion, 0.0, desired_up_portion)
		lift_force = max_vertical_force * frac/max_up_portion
		if lift_force.dot(total_force) > 0:
			lift_force *= -1
		#print(max_vertical_force,'|',frac,'|',desired_up_portion, '|', total_force + lift_force)
	else:
		lift_force = vertical * state_lift_alpha * char.velocity.length() * lift_vel_coef
	
	lift_force *= thin_air
	
	total_force += lift_force * delta * speed_factor
	
	#print(lift_force)
	
	char.velocity += total_force * delta
	char.move_and_slide()
	char.rotation = char.velocity.angle()
	#print(char.velocity.length(),'|',lift_force,'|',gravity_force,'|',state_lift_alpha,'|',throttle_force)

func set_movement_values(delta : float) -> void:
	#if Input.is_action_pressed("throttle"):
		#state_throttle_alpha += throttle_delta_scale * delta
	if Input.is_action_pressed("flaps"):
		state_flaps = true
	else:
		state_flaps = false
	state_throttle_alpha = 1.0
	state_throttle_alpha = clampf(state_throttle_alpha, -1, 1)
	state_lift_alpha += Input.get_axis("lift_up", "lift_down") * lift_delta_scale * delta
	if Input.get_axis("lift_up", "lift_down") == 0.0:
		if state_lift_alpha > 0:
			state_lift_alpha -= lift_delta_scale * delta
		elif state_lift_alpha < 0:
			state_lift_alpha += lift_delta_scale * delta
	state_lift_alpha = clampf(state_lift_alpha, -1.0, 1.0)
	var new_autopilot = not(Input.is_action_pressed("lift_down") or Input.is_action_pressed("lift_up"))
	if new_autopilot != state_autopilot_on:
		state_autopilot_on = new_autopilot

	
func _physics_process(delta: float) -> void:
	set_movement_values(delta)
	apply_movement(delta)
	#print(state_lift_alpha)
	var rect := get_viewport().get_visible_rect()
	#if char.position.x < 0:
		#char.position.x += rect.size.x
	#if char.position.x > rect.size.x:
		#char.position.x -= rect.size.x
	#if char.position.y < 0:
		#char.position.y += rect.size.y
	#if char.position.y > rect.size.y:
		#char.position.y -= rect.size.y

func set_thin_air(value : bool) -> void:
	var change := value == state_in_thin_air
	state_in_thin_air = value
	if change:
		if state_in_thin_air:
			SignalBus.entered_thin_air.emit()
		else:
			SignalBus.exited_thin_air
