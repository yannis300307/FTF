extends StaticBody2D

var closed = false

func _on_area_2d_body_exited(body: Node2D) -> void:
	if closed: return
	closed = true
	$closed.visible = true
	$AnimationPlayer.play("close")
	$true_collision.set_deferred("disabled",false)
