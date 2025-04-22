extends Control

var reverse_amount_v = 0
var reverse_amount_h = 0

func set_reverse_amount(amount: int, mode: int):
	if mode == 0:
		$reverse_btns/rv/reverse_v/reverse_amount.text = str(amount)
		reverse_amount_v = amount
	if mode == 1:
		$reverse_btns/rh/reverse_h/reverse_amount.text = str(amount)
		reverse_amount_h = amount
	
	$reverse_btns/rb/reverse_b/reverse_amount.text = str(min(reverse_amount_v, reverse_amount_h))

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

func _on_retry_pressed() -> void:
	$transition_animation.play("transition")
	await get_tree().create_timer(0.42).timeout
	Autoload.reset_level.emit()
