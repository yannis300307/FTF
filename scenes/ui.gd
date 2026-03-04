extends Control

var reverse_amount_v = 0
var reverse_amount_h = 0

var lock = false

func set_reverse_amount(amount: int, mode: int):
	if mode == 0:
		if $reverse_btns/rv/reverse_v/reverse_amount.text != str(amount): $reverse_btns/rv/reverse_v/AnimationPlayer.play("update")
		$reverse_btns/rv/reverse_v/reverse_amount.text = str(amount)
		reverse_amount_v = amount
		if reverse_amount_v:
			$reverse_btns/rv/reverse_v.disabled = false
		else:
			$reverse_btns/rv/reverse_v.disabled = true
	if mode == 1:
		if $reverse_btns/rh/reverse_h/reverse_amount.text != str(amount): $reverse_btns/rh/reverse_h/AnimationPlayer.play("update")
		$reverse_btns/rh/reverse_h/reverse_amount.text = str(amount)
		reverse_amount_h = amount
		if reverse_amount_h:
			$reverse_btns/rh/reverse_h.disabled = false
		else:
			$reverse_btns/rh/reverse_h.disabled = true
	
	if $reverse_btns/rb/reverse_b/reverse_amount.text != str(min(reverse_amount_v, reverse_amount_h)): $reverse_btns/rb/reverse_b/AnimationPlayer.play("update")
	$reverse_btns/rb/reverse_b/reverse_amount.text = str(min(reverse_amount_v, reverse_amount_h))
	if min(reverse_amount_v, reverse_amount_h):
		$reverse_btns/rb/reverse_b.disabled = false
	else:
		$reverse_btns/rb/reverse_b.disabled = true

func reset():
	reverse_amount_v = 0
	reverse_amount_h = 0
	set_reverse_amount(0, 0)
	set_reverse_amount(0, 1)

func _on_reverse_v_pressed() -> void:
	Autoload.ask_reverse.emit(true, false)

func _on_reverse_h_pressed() -> void:
	Autoload.ask_reverse.emit(false, true)

func _on_reverse_b_pressed() -> void:
	Autoload.ask_reverse.emit(true, true)

func _ready() -> void:
	Autoload.reset_level.connect(reset)
	Autoload.clear_items.connect(reset)
	Autoload.ask_reset.connect(reset_with_transition)
	Autoload.game_end.connect(game_end)

func game_end():
	if $transition_animation.is_playing():
		await $transition_animation.animation_finished
	$transition_animation.play("hide_ui")
	await $transition_animation.animation_finished
	get_parent().visible = false

func _on_retry_pressed() -> void:
	Autoload.ask_reset.emit()

func reset_with_transition():
	if $transition_animation.is_playing():
		await $transition_animation.animation_finished
	$transition_sound.play()
	$transition_animation.play("transition")
	await get_tree().create_timer(0.42).timeout
	Autoload.reset_level.emit()

func spawn():
	if $transition_animation.is_playing():
		await $transition_animation.animation_finished
	get_parent().visible = true
	$transition_animation.play("show_ui")
	await $transition_animation.animation_finished
