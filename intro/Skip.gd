extends CenterContainer

signal filled

const FILL_SPEED = 80
const EMPTY_SPEED = 60
const MODULATE_SPEED = 10


func _process(delta):
	if Input.is_action_pressed("ui_cancel") or Input.is_action_pressed("ui_accept"):
		$VBoxContainer/ProgressBar.value += FILL_SPEED * delta
	else:
		$VBoxContainer/ProgressBar.value -= EMPTY_SPEED * delta
	var alpha = 1 if $VBoxContainer/ProgressBar.value else 0
	modulate.a = lerp(modulate.a, alpha, MODULATE_SPEED*delta)
	
	if $VBoxContainer/ProgressBar.value == 100:
		emit_signal("filled")
		set_process(false)
