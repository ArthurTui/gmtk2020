extends Node

export var stream = preload("res://assets/sound/sfx/peacockscream.wav")
export var base_db := 0.0
export var db_var := 0.0
export var base_pitch := 1.0
export var pitch_var := 0.0

onready var Player = $AudioStreamPlayer

func _ready():
	Player.stream.audio_stream = stream
	
	randomize()
	Player.volume_db = base_db + rand_range(-db_var, db_var)
	
	Player.stream.random_pitch = 1 + pitch_var
	Player.pitch_scale = base_pitch

func _on_AudioStreamPlayer_finished():
	queue_free()
