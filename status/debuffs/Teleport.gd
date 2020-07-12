extends Status

signal teleport

func _on_Timer_timeout():
	emit_signal("teleport")
