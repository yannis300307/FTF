extends StaticBody2D

var closed = false
var inside = false

func _ready() -> void:
	Autoload.reset_level.connect(reset)

func reset():
	closed = false
	inside = false
	$closed.visible = false
	$true_collision.set_deferred("disabled",true)
	

func _on_area_2d_body_exited(body: Node2D) -> void:
	if closed: return
	if not inside: return
	if body != get_node("/root/main/player"): return
	closed = true
	$closed.visible = true
	$close_sound.play()
	$AnimationPlayer.play("close")
	$true_collision.set_deferred("disabled",false)


func _on_area_2d_body_entered(body: Node2D) -> void:
	inside = true
