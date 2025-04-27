extends StaticBody2D

signal pressed
signal released
signal toggle(state: bool)

@export var state_pressed = true

var easter_mouse_clicks = 0

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


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	print("aaa")
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		easter_mouse_clicks += 1
		if easter_mouse_clicks >= 5:
			$easter_egg_sound.play()
			easter_mouse_clicks = 0
