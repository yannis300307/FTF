extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		body.linear_velocity.y = 0.
		body.apply_central_impulse(Vector2(0., -1200.))
		$bounce.pitch_scale = 1+Autoload.rng.randf()*0.2
		$bounce.play()
		$AnimationPlayer.play("bounce")
