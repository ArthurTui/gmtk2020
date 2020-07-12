extends Control

func _ready():
	AudioManager.play_bgm("intro", 1)

func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().quit()

func _on_NewGame_pressed():
	$"/root/AudioManager".stop_bgm()
	Transition.transition_to_scene("res://intro/intro.tscn")


func _on_Quit_pressed():
	get_tree().quit()


func _on_Credits_pressed():
	Transition.transition_to_scene("res://credits/credits.tscn")
