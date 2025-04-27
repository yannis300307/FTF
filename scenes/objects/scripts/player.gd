extends RigidBody2D

@export var strenght: float = 80000.0

var can_move = true
var in_transition = false


func _ready():
	freeze_mode = RigidBody2D.FREEZE_MODE_STATIC
	Autoload.player_death.connect(die)
	Autoload.update_level_transition.connect(func(start: bool): $CollisionShape2D.disabled = start; $walls_detector.monitoring = not start)
	
func die():
	if in_transition: return
	set_deferred("freeze", true)
	can_move = false
	in_transition = true
	linear_velocity /= 100
	$AnimationPlayer.play("death")
	await $AnimationPlayer.animation_finished
	set_deferred("freeze", false)
	Autoload.ask_reset.emit()

func _process(delta: float) -> void:
	if not can_move: return
	var strenght_to_apply = strenght
	if get_colliding_bodies().size() == 0:
		strenght_to_apply /= 3.0
	if Input.is_action_pressed("ui_left"):
		apply_force(Vector2(-strenght_to_apply*delta, 0.))
	if Input.is_action_pressed("ui_right"):
		apply_force(Vector2(strenght_to_apply*delta, 0.))
	

func finish_level(exact_coords: Vector2):
	if in_transition: return
	in_transition = true
	can_move = false
	set_axis_velocity(Vector2(0, 0))
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "global_position", exact_coords, 1.0)
	
	await get_tree().create_timer(0.5).timeout
	$AnimationPlayer.play("level_end")
	
	await tween.finished
	Autoload.next_level.emit()
	in_transition = false
	visible = false
	

func teleport(pos: Vector2):
	PhysicsServer2D.body_set_state(
		get_rid(),
		PhysicsServer2D.BODY_STATE_TRANSFORM,
		Transform2D.IDENTITY.translated(pos)
	)

func respawn(pos: Vector2):
	can_move = false
	in_transition = true
	teleport(pos)
	visible = true
	$AnimationPlayer.play("spawn")
	await $AnimationPlayer.animation_finished
	can_move = true
	in_transition = false


func _on_core_body_entered(body: Node2D) -> void:
	if Autoload.current_level != null and body == Autoload.current_level.get_node("centering/map"):
		Autoload.player_death.emit()

func _on_walls_detector_body_entered(body: Node2D) -> void:
	$floor_hit.pitch_scale = 1+Autoload.rng.randf()*0.2
	$floor_hit.play()
