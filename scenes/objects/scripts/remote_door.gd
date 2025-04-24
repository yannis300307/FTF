extends StaticBody2D

@export var default_closed = true
var closed = false

func _ready() -> void:
	reset()
	Autoload.reset_level.connect(reset)

func reset():
	closed = default_closed
	if closed:
		$closed.visible = true
		$closed.scale = Vector2(0.5, 0.5)
		$true_collision.set_deferred("disabled", false)
	else:
		$closed.visible = false
		$true_collision.set_deferred("disabled", true)

func toggle(_state: bool):
	if closed:
		open()
	else:
		close()

func open() -> void:
	if not closed: return
	closed = false
	$closed.scale = Vector2(0.5, 0.5)
	$AnimationPlayer.play("open")
	$true_collision.set_deferred("disabled", true)
	await $AnimationPlayer.animation_finished
	$closed.visible = false
	
func close() -> void:
	if closed: return
	closed = true
	$closed.visible = true
	$AnimationPlayer.play("close")
	$true_collision.set_deferred("disabled", false)
	await $AnimationPlayer.animation_finished
	$closed.scale = Vector2(0.5, 0.5)
