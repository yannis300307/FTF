extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body != get_node("/root/main/player"): return
	$clear_sound.play()
	$AnimationPlayer.play("pass")
	Autoload.clear_items.emit()
