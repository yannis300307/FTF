extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body != get_node("/root/main/player"): return
	Autoload.player_death.emit()
	print("assdfbvbnvb")
