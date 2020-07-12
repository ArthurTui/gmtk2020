extends CanvasLayer

const FULL_HEART = preload("res://assets/images/HUD/life.png")
const EMPTY_HEART = preload("res://assets/images/HUD/life lost.png")
const HALF_HEART = preload("res://assets/images/HUD/half-life.png")

var prev_life = 100

func update_life(cur_life):
	var n = ceil(cur_life/20.0)
	if cur_life > 0:
		var half_heart = (int(floor(cur_life))%20) <= 10

		for i in range(1, n):
			get_node("LifeContainer/Heart"+str(i)).texture = FULL_HEART
		
		var cur_heart = get_node("LifeContainer/Heart"+str(n))
		if prev_life > cur_life:
			cur_heart.shake()
		prev_life = cur_life
		if half_heart:
			cur_heart.texture = HALF_HEART
		else:
			cur_heart.texture = FULL_HEART
		
	for i in range(n+1, 6):
		get_node("LifeContainer/Heart"+str(i)).texture = EMPTY_HEART

func _ready():
	pass # Replace with function body.
