extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	for dinozaur in $Dinozaury.get_children():
		if dinozaur is Dinozaur:
			var siedlisko: Siedlisko = $Siedliska.get_children().pick_random()
			while not siedlisko.obecni.is_empty():
				siedlisko = $Siedliska.get_children().pick_random()
			siedlisko.obecni.append(dinozaur)
			dinozaur.aktualne_siedlisko = siedlisko
			dinozaur.position = siedlisko.position
	
	for leże in $Siedliska.get_children():
		if leże is Siedlisko:
			leże.wylosuj_zdobycz()
			leże.nawiąż_połączenie()
			leże.klikalny = true



func nowa_tura():
	for siedlisko in $Siedliska.get_children():
		if siedlisko is Siedlisko:
			if siedlisko.klikalny:
				siedlisko.klikalny = false
			else:
				return
	
	for dino in $Dinozaury.get_children():
		if dino is Dinozaur:
			przesuń_dinozaura(
				dino,
				dino.aktualne_siedlisko.połączenia.pick_random()
				)
	
	await get_tree().create_timer(0.2).timeout
	
	
	for siedlisko in $Siedliska.get_children():
		if siedlisko is Siedlisko:
			siedlisko.rozstrzygnij_walkę()
	
	
	await get_tree().process_frame
	
	
	for siedlisko in $Siedliska.get_children():
		siedlisko.przyznaj_zdobycz()
		siedlisko.wylosuj_zdobycz()
		siedlisko.nawiąż_połączenie()
		siedlisko.klikalny = true

func przesuń_dinozaura(dino: Dinozaur, leże: Siedlisko):
	if leże == null:
		return
	if dino.aktualne_siedlisko != null:
		dino.aktualne_siedlisko.obecni = []
	dino.aktualne_siedlisko = leże
	leże.obecni.append(dino)
	var twink: Tween = create_tween()
	twink.tween_property(
		dino,
		"position",
		leże.position,
		0.2
		).set_ease(Tween.EASE_IN_OUT)


