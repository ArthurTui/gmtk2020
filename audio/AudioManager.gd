extends Node

func get_sfx(name : String):
	for child in $SFXs.get_children():
		if child.name.to_lower() == name.to_lower():
			var sfx = child.duplicate()
			sfx.setup()
			return sfx
	assert(false, "Couldn't find sfx:" + str(name))
