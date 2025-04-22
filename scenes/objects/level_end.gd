extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body == get_node("/root/main/player"):
		get_node("/root/main/player").finish_level(global_position)

func wait_transition(value: bool):
	monitoring = not value
