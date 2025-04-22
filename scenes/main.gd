extends Node2D

@export var levels: Array[Node2D]

var current_level = -1

func _ready() -> void:
	Autoload.next_level.connect(next_level)
	next_level(true)
	Autoload.reset_level.connect(reset)
	
func next_level(instant: bool = false):
	current_level += 1
	if current_level >= levels.size():
		current_level = -1
		Autoload.current_level
	else:
		#$camera.global_position = levels[current_level].global_position
		Autoload.current_level = levels[current_level]
		var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT)
		tween.tween_property($camera, "global_position", levels[current_level].global_position, 0.0 if instant else 1.0).set_ease(Tween.EASE_IN_OUT)
		await tween.finished
		
		Autoload.reset_level.emit()

func reset():
	$player.respawn(levels[current_level].get_node("centering/player_spawn").global_position)
