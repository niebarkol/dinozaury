class_name Siedlisko
extends Area2D

var połączenia: Array
var linie: CanvasGroup
var klikalny: bool = false
var zdobycz:= 0
var obecni: Array

var krew = preload("res://sceny/krew.tscn")

signal nawiazane_polaczenie(partner: Siedlisko)
signal kliknięto(co: Siedlisko)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _draw():
	for połączenie in połączenia:
		#draw_line(position,połączenie.position,Color.RED)
		draw_line(Vector2.ZERO,połączenie.position-position,Color.RED,10)

func _on_button_pressed():
	pass # Replace with function body.

func nawiąż_połączenie():
	połączenia = []
	for siedlisko in $"Zasięg".get_overlapping_areas():
		if siedlisko == self:
			continue
		if randi_range(0,1):
			połączenia.append(siedlisko)
			siedlisko.emit_signal("nawiazane_polaczenie", get_node(get_path()))
	queue_redraw()

func _gdy_nawiazane_polaczenie(partner):
	await get_tree().process_frame
	queue_redraw()
	if partner not in połączenia:
		połączenia.append(partner)
#	print(self, połączenia)

		

func wylosuj_zdobycz():
	if zdobycz == 0 and obecni.is_empty():
		if not randi_range(0, 10):
			zdobycz = randi_range(1, 3)
	elif not randi_range(0, 7):
		zdobycz = 0
	
	if zdobycz == 0:
		$Label.text = ""
	else:
		$Label.text = str(zdobycz)

func przyznaj_zdobycz():
	if zdobycz > 0 and not obecni.is_empty():
		var dino: Dinozaur = obecni[0]
		dino.potęga += zdobycz
		zdobycz = 0
		dino.find_child("Label").text = str(dino.potęga)


func rozstrzygnij_walkę():
	if obecni.size() > 1:
		var porównanie_sił = func (pierwszy, drugi) -> bool:
			if pierwszy is Dinozaur and drugi is Dinozaur:
				if pierwszy.potęga > drugi.potęga:
					return true
				else:
					return false
			elif not pierwszy is Dinozaur:
				return false
			else:
				return true
		
		obecni.sort_custom(porównanie_sił)
		for przegrany in obecni.slice(1):
			if przegrany is Dinozaur:
				przegrany.queue_free()
				zrob_krew()
				
		obecni = [obecni[0]]
		#TODO: może dodać jakiś efekt zabijania

func zrob_krew():
	var flaki = krew.instantiate()
	add_child(flaki)
	flaki.emitting = true
	await get_tree().create_timer(flaki.lifetime).timeout
	flaki.queue_free()
	


func _on_kliknięcie():
	emit_signal("kliknięto", self)

