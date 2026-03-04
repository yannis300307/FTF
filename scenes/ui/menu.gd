extends Control

func _on_play_pressed() -> void:
	Autoload.start_game.emit()


func _on_credits_pressed() -> void:
	$transitions.play("show_credits")


func _on_back_to_menu_pressed() -> void:
	$transitions.play("back_to_menu")


func _on_close_pressed() -> void:
	get_tree().quit()
