extends RigidBody2D

@export var strenght: float = 500.0

var can_move = true
var in_transition = false

func _ready():
	freeze_mode = RigidBody2D.FREEZE_MODE_STATIC

func _process(delta: float) -> void:
	if not can_move: return
	if Input.is_action_pressed("ui_left"):
		apply_force(Vector2(-strenght, 0.))
	if Input.is_action_pressed("ui_right"):
		apply_force(Vector2(strenght, 0.))

func finish_level(exact_coords: Vector2):
	if in_transition: return
	in_transition = true
	can_move = false
	set_axis_velocity(Vector2(0, 0))
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK)
	tween.set_parallel()
	tween.tween_property(self, "global_position", exact_coords, 2.0)
	tween.tween_property(self, "in_transition", false, 0.0).set_delay(2.0)
	tween.tween_callback(func():$AnimationPlayer.play("level_end")).set_delay(1.0)
	tween.tween_property(self, "visible", false, 0.0).set_delay(2.0)
