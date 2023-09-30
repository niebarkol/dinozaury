extends CanvasGroup


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	for połączenie in get_parent().połączenia:
		#draw_line(position,połączenie.position,Color.RED)
		draw_line(Vector2.ZERO,połączenie.position-position,Color.RED,10)
