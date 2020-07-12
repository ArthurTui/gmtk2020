extends TextureRect


func shake():
	if $AnimationPlayer.current_animation == "idle":
		$AnimationPlayer.play("shake")

func idle():
	$AnimationPlayer.play("idle")
