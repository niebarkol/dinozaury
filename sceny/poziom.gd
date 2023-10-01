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
			dinozaur.zmień_kolor(losowy_kolor(dinozaur))
	
	for leże in $Siedliska.get_children():
		if leże is Siedlisko:
			await get_tree().process_frame
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
			var kierunek_poruszenia: Vector2 = dino.ewaluuj_kierunek($Siedliska.get_children())
			print(dino, kierunek_poruszenia)
			var możliwe_kierunki: Array = dino.aktualne_siedlisko.połączenia
			if możliwe_kierunki.is_empty():
				continue
			#ta lambda została mi objawiona o 3:00  przez Lemury, nie kwestionować
			#3:20 update, sama nie wiem czy to działa, niech ktoś proszę to zakwestionuje
			var sort_wg_atrakcyjnosci = func (
				pierwsze: Siedlisko, drugie: Siedlisko) -> bool:
					if cos(position.direction_to(pierwsze.position) \
						.angle_to(kierunek_poruszenia)) < cos(position \
							.direction_to(drugie.position).angle_to(kierunek_poruszenia)):
								return false
					else:
						return true
			możliwe_kierunki.sort_custom(sort_wg_atrakcyjnosci)
			print(dino, position.direction_to(możliwe_kierunki[0].position).angle_to(kierunek_poruszenia))
			przesuń_dinozaura(
				dino,
				możliwe_kierunki[0]
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

func losowy_kolor(obiekt: Node) -> Color:
	#DLACZEGO TO MI DAJE TE SAME KOLORY DLA WSZYSTKICH AAAA KURWA
	var rng = RandomNumberGenerator.new()
	rng.seed = obiekt.to_string().hash()
	return Color(
		rng.randf_range(0,1),
		rng.randf_range(0,1),
		rng.randf_range(0,1),
	)
