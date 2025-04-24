extends Area2D


func _on_body_entered(body: Node2D) -> void:
	$AnimationPlayer.play("pass")
	Autoload.clear_items.emit()
