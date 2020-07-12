extends Control


func _on_NewGame_pressed():
	Transition.transition_to_scene("res://game/Game.tscn")


func _on_Quit_pressed():
	get_tree().quit()
