extends Control

func _ready():
	AudioManager.play_bgm("intro", 1)

func _on_NewGame_pressed():
	Transition.transition_to_scene("res://intro/intro.tscn")


func _on_Quit_pressed():
	get_tree().quit()
