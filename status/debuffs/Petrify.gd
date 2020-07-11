extends Status

signal stun

export var stun_duration := 2.0

func _ready():
	emit_signal("stun", duration)
