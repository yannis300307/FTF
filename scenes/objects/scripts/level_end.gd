extends Area2D

var finished = false

func _on_body_entered(body: Node2D) -> void:
	if finished: return
	if body == get_node("/root/main/player"):
		finished = true
		$finish.play()
		get_node("/root/main/player").finish_level(global_position)

func wait_transition(value: bool):
	monitoring = not value
