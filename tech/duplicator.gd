extends Node
class_name Duplicator

@export var root : Node2D

class Item:
	var main : Node2D
	var negative : Node2D
	var positive : Node2D

var items : Array[Item]

func add_item(node : Node) -> void:
	if node.get_parent() == root and node is Node2D and not node.is_in_group("duplicates") and node.is_in_group("main"):
	#if node is Node2D:
		print(node)
		var item = Item.new()
		item.main = node
		item.main.add_to_group("main")
		item.negative = node.duplicate()
		item.negative.global_position.x -= get_viewport().get_visible_rect().size.x
		item.positive = node.duplicate()
		item.positive.global_position.x += get_viewport().get_visible_rect().size.x
		item.negative.add_to_group("duplicates")
		item.positive.add_to_group("duplicates")
		root.add_child(item.negative)
		root.add_child(item.positive)
		items.push_back(item)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	root.child_entered_tree.connect(add_item)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(items[0].main,'|',items[0].negative,'|', items[0].positive,'\n')
	#print(items.size())
	var to_delete : Array[Item] = []
	for item in items:
		if not item.main:
			if item.negative:
				item.negative.queue_free()
			if item.positive:
				item.negative.queue_free()
			to_delete.push_back(item)
		var rect := get_viewport().get_visible_rect()
		if item.main.global_position.x < 0:
			item.negative.queue_free()
			item.negative = item.main
			item.negative.remove_from_group("main")
			item.negative.add_to_group("duplicates")
			item.main = item.positive
			item.positive = item.main.duplicate()
			item.positive.global_position.x += rect.size.x
			item.positive.remove_from_group("main")
			item.positive.add_to_group("duplicates")
			root.add_child(item.positive)
			item.main.add_to_group("main")
			item.main.remove_from_group("duplicates")
		elif item.main.global_position.x > rect.size.x:
			item.positive.queue_free()
			item.positive = item.main
			item.positive.remove_from_group("main")
			item.positive.add_to_group("duplicates")
			item.main = item.negative
			item.negative = item.main.duplicate()
			item.negative.global_position.x -= rect.size.x
			item.negative.remove_from_group("main")
			item.negative.add_to_group("duplicates")
			root.add_child(item.negative)
			item.main.add_to_group("main")
			item.main.remove_from_group("duplicates")
		if item.negative.has_method("duplicate_copy_main"):
			item.negative.duplicate_copy_main(item.main)
		if item.positive.has_method("duplicate_copy_main"):
			item.positive.duplicate_copy_main(item.main)
	for item in to_delete:
		items.erase(item)
