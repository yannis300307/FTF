extends Control



func _on_play_pressed() -> void:
	Autoload.start_game.emit()
