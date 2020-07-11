extends Control


func _on_NewGame_pressed():
	Transition.transition_to_scene("res://test/Test.tscn")


func _on_Quit_pressed():
	get_tree().quit()
