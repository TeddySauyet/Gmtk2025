extends Area2D
class_name Loop


var polygon : PackedVector2Array : set = set_polygon
	
func _ready() -> void:
	body_entered.connect(on_body_entered)

func on_body_entered(node : Node2D) -> void:
	print('xxx')
	if node.is_in_group("main"):
		if node.has_method("got_looped"):
			node.got_looped()

func set_polygon(value : PackedVector2Array) -> void:
	polygon = value
	$CollisionPolygon2D.polygon = polygon
	
