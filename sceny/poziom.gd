extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	for dinozaur in $Dinozaury.get_children():
		if dinozaur is Dinozaur:
			var siedlisko: Siedlisko = $Siedliska.get_children().pick_random()
			while siedlisko.zasiedlajacy_dinozaur != null:
				siedlisko = $Siedliska.get_children().pick_random()
			siedlisko.zasiedlajacy_dinozaur = dinozaur
			dinozaur.aktualne_siedlisko = siedlisko
			dinozaur.position = siedlisko.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	for siedlisko in $Siedliska.get_children():
		siedlisko.emit_signal("nowa_tura")
	
	for dino in $Dinozaury.get_children():
		if dino is Dinozaur:
			print(dino.aktualne_siedlisko)
			if not dino.aktualne_siedlisko.połączenia.is_empty():
					print("B")
					przesuń_dinozaura(
						dino,
						dino.aktualne_siedlisko.połączenia.pick_random()
						)

func przesuń_dinozaura(dino: Dinozaur, leże: Siedlisko):
	if dino.aktualne_siedlisko != null:
		dino.aktualne_siedlisko.zasiedlajacy_dinozaur = null
	dino.aktualne_siedlisko = leże
	
	if leże.zasiedlajacy_dinozaur != null:
		var przeciwnik: Dinozaur = leże.zasiedlajacy_dinozaur
		if przeciwnik.potęga == dino.potęga:
			var losowy: Dinozaur = [dino, przeciwnik].pick_random()
			losowy.queue_free()
			if losowy == dino:
				return
		elif przeciwnik.potęga < dino.potęga:
			przeciwnik.queue_free()
		else:
			dino.queue_free()
			return
	dino.position = leże.position
	
	if leże.zdobycz > 0:
		dino.potęga += leże.zdobycz
		leże.zdobycz = 0
		dino.find_child("Label").text = str(dino.potęga)
