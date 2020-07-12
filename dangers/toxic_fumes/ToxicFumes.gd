extends Node

export var damage := 40

func _on_Area2D_body_entered(body):
	if body is Player:
		body.take_damage(damage)
		body.add_status(Status.TYPES.ACIDBURNING)
		$Burst.play()
		$Sprite.stop()
		$Sprite.animation = "activating"
		$Sprite.frame = 0
		$Sprite.play()
		yield($Sprite, "animation_finished")
		if $Sprite.animation == "activating":
			$Sprite.stop()
			$Sprite.animation = "active"
			$Sprite.frame = 0
			$Sprite.play()
			$Loop.play()

func _on_Area2D_body_exited(body):
	if body is Player:
		body.remove_status(body.status_array[Status.TYPES.ACIDBURNING])
		$Sprite.stop()
		$Sprite.animation = "deactivating"
		$Sprite.frame = 0
		$Sprite.play()
		yield($Sprite, "animation_finished")
		if $Sprite.animation == "deactivating":
			$Loop.stop()
			$Sprite.stop()
			$Sprite.animation = "default"
			$Sprite.frame = 0
			$Sprite.play()
