extends Node

export var stream = preload("res://assets/sound/sfx/peacockscream.wav")
export var base_db := 0.0
export var db_var := 0.0
export var base_pitch := 1.0
export var pitch_var := 0.0

func setup():
	var player = $AudioStreamPlayer
	
	player.stream.audio_stream = stream
	
	randomize()
	player.volume_db = base_db + rand_range(-db_var, db_var)
	
	player.stream.random_pitch = 1 + pitch_var
	player.pitch_scale = base_pitch
	
	player.autoplay = true

func _on_AudioStreamPlayer_finished():
	queue_free()
