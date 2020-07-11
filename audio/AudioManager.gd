extends Node


func get_sfx(name : String):
	for child in $SFXs.get_children():
		if child.name.to_lower() == name.to_lower():
			return child.duplicate()
	assert(false, "Couldn't find sfx:" + str(name))
