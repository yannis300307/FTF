extends Node2D

var reverse_item_picked_vertical = 0
var reverse_item_picked_horizontal = 0

var x_reversed = false
var y_reversed = false

var rng = RandomNumberGenerator.new()

func reset():
	reverse_item_picked_vertical = 0
	reverse_item_picked_horizontal = 0
	x_reversed = false
	y_reversed = false
	flip_center(false, false)
	

func flip_center(x_reverse: bool, y_reverse: bool, delay: float = 0.0):
	get_node("/root/main/player").set_deferred("freeze", true)
	$level_end.wait_transition(true)
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK)
	tween.set_parallel()
	var level_size = $map.get_used_rect().size*$map.tile_set.tile_size
	var target_x = level_size.x/2 * (1 if x_reverse else -1)
	var target_y = level_size.y/2 * (1 if y_reverse else -1)

	var target_scale = Vector2(-1 if x_reverse else 1, -1 if y_reverse else 1)
	
	tween.tween_property(self, "scale", target_scale, delay)
	tween.tween_property(self, "position", Vector2(target_x, target_y), delay).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(func():get_node("/root/main/player").set_deferred("freeze", false)).set_delay(delay)
	tween.tween_callback(func():$level_end.wait_transition(false)).set_delay(delay)

	x_reversed = x_reverse
	y_reversed = y_reverse

func add_one_reverse_item(mode: int):
	if mode == 0:
		reverse_item_picked_vertical += 1
		get_node("/root/main/UI/UI").set_reverse_amount(reverse_item_picked_vertical, mode)
	if mode == 1:
		reverse_item_picked_horizontal += 1
		get_node("/root/main/UI/UI").set_reverse_amount(reverse_item_picked_horizontal, mode)


func _ready() -> void:
	flip_center(false, false)
	Autoload.reverse_item_picked_up.connect(add_one_reverse_item)
	
	# Generate the map shadow
	var shadow_map: TileMapLayer = $map.duplicate()
	shadow_map.material = ShaderMaterial.new()
	shadow_map.material.shader = preload("res://shaders/shadow.gdshader")
	shadow_map.material.set("shader_parameter/shadow_offset", Vector2(30., 30.))
	add_child(shadow_map, false, 1)
	
	Autoload.ask_reverse.connect(ask_reverse)
	Autoload.reset_level.connect(reset)


func ask_reverse(x_reverse: bool, y_reverse: bool):
	if Autoload.current_level != get_parent(): return
	
	if ((x_reverse and not y_reverse) and reverse_item_picked_vertical) or ((y_reverse and not x_reverse) and reverse_item_picked_horizontal) or ((x_reverse and y_reverse) and reverse_item_picked_horizontal):
		if x_reverse and y_reverse:
			flip_center(not x_reversed, not y_reversed, 0.5)
			reverse_item_picked_vertical -= 1
			reverse_item_picked_horizontal -= 1
		if x_reverse and (not y_reverse):
			flip_center(not x_reversed, y_reversed, 0.5)
			reverse_item_picked_vertical-= 1
		if (not x_reverse) and y_reverse:
			flip_center(x_reversed, not y_reversed, 0.5)
			reverse_item_picked_horizontal -= 1
		
		if x_reverse:
			get_node("/root/main/UI/UI").set_reverse_amount(reverse_item_picked_vertical, 0)
		if y_reverse:
			get_node("/root/main/UI/UI").set_reverse_amount(reverse_item_picked_horizontal, 1)
