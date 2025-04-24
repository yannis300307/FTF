extends StaticBody2D

signal pressed
signal released
signal toggle(state: bool)

@export var state_pressed = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body != get_node("/root/main/player"): return
	$push_sound.play()
	$AnimationPlayer.play("press")
	pressed.emit()
	if state_pressed:
		toggle.emit(false)
		state_pressed = false
	else:
		toggle.emit(true)
		state_pressed = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body != get_node("/root/main/player"): return
	released.emit()
	$AnimationPlayer.play("release")
