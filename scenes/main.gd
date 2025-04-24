extends Node2D

@export var levels: Array[Node2D]

var current_level = -1

@export var start_level = 0

func _ready() -> void:
	current_level = start_level - 1
	Autoload.next_level.connect(next_level)
	next_level(true, true)
	Autoload.reset_level.connect(reset)	
	Autoload.level_flipped.connect($level_flip.play)
	Autoload.start_game.connect(
	func():
		next_level()
		)
	
func next_level(instant: bool = false, restart: bool = false):
	if restart:
		current_level = -1
	else:
		current_level += 1
	if current_level >= levels.size() or restart:
		current_level = -1
		Autoload.current_level = null
		$UI.visible = false
		$bg_particles.global_position = $menu.global_position
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUART)
		tween.tween_property($camera, "global_position", $menu.global_position, 0.0 if instant else 1.0).set_ease(Tween.EASE_IN_OUT)
		await tween.finished
	else:
		if not $UI.visible: $UI/UI.spawn()
		#$camera.global_position = levels[current_level].global_position
		Autoload.update_level_transition.emit(true)
		Autoload.current_level = levels[current_level]
		$pre_emitter.global_position = levels[current_level].global_position
		$pre_emitter.restart()
		$pre_emitter.emitting = true
		
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUART)
		tween.tween_property($camera, "global_position", levels[current_level].global_position, 0.0 if instant else 1.0).set_ease(Tween.EASE_IN_OUT)
		await tween.finished
		
		Autoload.reset_level.emit()
		Autoload.update_level_transition.emit(false)
		
		$bg_particles.global_position = levels[current_level].global_position
		
		await get_tree().create_timer(20).timeout
		
		$pre_emitter.emitting = false

func reset():
	await Autoload.current_level.get_node("centering").reset()
	$player.respawn(levels[current_level].get_node("centering/player_spawn").global_position)
