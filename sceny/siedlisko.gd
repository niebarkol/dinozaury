class_name Siedlisko
extends Area2D

var połączenia: Array
var linie: CanvasGroup
var klikalny: bool
var zdobycz:= 0

signal nowa_tura
signal nawiazane_polaczenie(partner: Siedlisko)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _nowa_tura():
	klikalny= false
	połączenia = []
	
	for siedlisko in $"Zasięg".get_overlapping_areas():
		if siedlisko == self:
			continue
		if randi_range(0,1):
			połączenia.append(siedlisko)
			siedlisko.emit_signal("nawiazane_polaczenie", get_node(get_path()))
			queue_redraw()
	
	
	if zdobycz == 0:
		if not randi_range(0, 10):
			zdobycz = randi_range(1, 3)
	elif not randi_range(0, 7):
		zdobycz = 0
	
	if zdobycz == 0:
		$Label.text = ""
	else:
		$Label.text = str(zdobycz)
	
	
	await get_tree().process_frame
	await get_tree().process_frame
	klikalny = true
	

func _draw():
	for połączenie in połączenia:
		#draw_line(position,połączenie.position,Color.RED)
		draw_line(Vector2.ZERO,połączenie.position-position,Color.RED,10)

func _on_button_pressed():
	pass # Replace with function body.


func _gdy_nawiazane_polaczenie(partner):
	await get_tree().process_frame
	if partner not in połączenia:
		połączenia.append(partner)
#	print(self, połączenia)
