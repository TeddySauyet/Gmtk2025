extends Node2D
class_name Trail

#pop front, push back
var trail_markers : Array[TrailMarker]

@export var min_distance : float = 20
@export var spawn_parent : Node2D

var need_to_spawn := false

func _ready() -> void:
	var a1 = Vector2(0, 0)
	var a2 = Vector2(1, 1)
	var b1 = Vector2(1,0)
	var b2 = Vector2(0,1)
	#print_debug(get_line_segment_intersection(a1,a2,b1,b2))
	

func _process(delta: float) -> void:
	if trail_markers.size() == 0:
		if spawn_parent:
			spawn_marker()
	elif (global_position - trail_markers[-1].global_position).length() > min_distance:
		if spawn_parent:
			spawn_marker()
		
func spawn_marker() -> void:
	var marker := preload("res://player/trail_marker.tscn").instantiate()
	marker.global_position = global_position
	marker.alpha = (1.0 + cos(global_rotation + PI))/2.0
	trail_markers.push_back(marker)
	spawn_parent.add_child(marker)
	marker.dead.connect(marker_dead)
	var idx := check_latest_for_collision()
	var x : int = NAN
	if x != idx:
		spawn_collision(idx)
	
	
func marker_dead(marker : TrailMarker) -> void:
	trail_markers.erase(marker)
	
func get_line_segment_intersection(a1 : Vector2, a2 : Vector2,
	b1 : Vector2, b2 : Vector2) -> Vector2:
		var am := (a2.y - a1.y)/(a2.x - a1.x)
		var bm := (b2.y - b1.y)/(b2.x - b1.x)
		#am*(x - a1.x) + a1.y = bm*(x - b1.x) + b1.y
		#x*(am - bm) = b1.y + a1.x*am - bm*b1.x - a1.y
		var x = (b1.y + a1.x*am - bm*b1.x - a1.y)/(am - bm)
		var y = am * (x - a1.x) + a1.y
		if x >= min(a1.x, a2.x) and \
				x <= max(a1.x, a2.x) and \
				y >= min(a1.y, a2.y) and \
				y <= max(a1.y, a2.y) and \
				x >= min(b1.x, b2.x) and \
				x <= max(b1.x, b2.x) and \
				y >= min(b1.y, b2.y) and \
				y <= max(b1.y, b2.y):
			#print("XXXXXXXXXXXXXXXXXXXXXXXXXXXX")
			return Vector2(x,y)
		return Vector2(NAN, NAN)

func check_latest_for_collision() -> int:
	if trail_markers.size() < 3:
		return NAN
	var result : TrailMarker = null
	var a1 := trail_markers[-1].global_position
	var a2 := trail_markers[-2].global_position
	for idx in range(0,trail_markers.size() - 3):
		var b1 := trail_markers[idx].global_position
		var b2 := trail_markers[idx+1].global_position
		var test_intersection := get_line_segment_intersection(a1, a2, b1, b2)
		if is_nan(test_intersection.x) or is_nan(test_intersection.y):
			pass
		else:
			return idx
	return NAN


func spawn_collision(start_idx : int) -> void:
	#trail_markers[start_idx].scale *= Vector2(3,3)
	var loop = preload("res://player/loop.tscn").instantiate()
	var poly : PackedVector2Array
	poly.resize(trail_markers.size() - start_idx)
	for idx in range(start_idx, trail_markers.size()):
		poly[idx-start_idx] = trail_markers[idx].global_position
	loop.polygon = poly
	spawn_parent.add_child(loop)
