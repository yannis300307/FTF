class_name ReverseItem
extends Area2D

@export var mode = 0

func _ready() -> void:
	visible = false
	if mode == 0:
		$sprites/horizontal.visible = false
	elif mode == 1:
		$sprites/vertical.visible = false
	
	Autoload.reset_level.connect(spawn)
	$AnimationPlayer2.play("wait")

func _on_body_entered(body: Node2D) -> void:
	if body == get_node("/root/main/player"):
		Autoload.reverse_item_picked_up.emit(mode)
		$AnimationPlayer.play("pick up")
		set_deferred("monitoring", false)

func spawn():
	if get_parent().get_parent() != Autoload.current_level: return
	visible = true
	$AnimationPlayer.play("spawn")
	monitoring = true
