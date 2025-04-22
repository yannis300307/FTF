class_name ReverseItem
extends Area2D

@export var mode = 0

func _on_body_entered(body: Node2D) -> void:
	if body == get_node("/root/main/player"):
		Autoload.reverse_item_picked_up.emit(mode)
		queue_free()
