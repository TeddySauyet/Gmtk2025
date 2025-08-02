extends HBoxContainer
class_name _GameState


class Level:
	@export var scene: PackedScene
	var n_attemps : int = 0
	
	static func Create()
	
var levels = Array[Level]

func _ready() -> void:
	levels = [
		
	]
