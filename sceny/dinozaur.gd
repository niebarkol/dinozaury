class_name Dinozaur
extends Node2D

var aktualne_siedlisko: Siedlisko
var potęga:= 0
var theme_color: Color


# Called when the node enters the scene tree for the first time.
func zmień_kolor(kolor: Color):
	theme_color = kolor
	$Label.label_settings.font_color = theme_color

func ewaluuj_kierunek(siedliska: Array) -> Vector2:
	var wektor_wyboru:= Vector2.ZERO
	for leże in siedliska:
		if leże is Siedlisko:
			if leże == aktualne_siedlisko:
				continue
			var kierunek := 10000000*position.direction_to(leże.position) / \
				position.distance_squared_to(leże.position)
			wektor_wyboru+= leże.zdobycz * kierunek
			if not leże.obecni.is_empty():
				var zagrożenie = leże.obecni[0]
				if zagrożenie.potęga < potęga:
					wektor_wyboru += kierunek
				elif zagrożenie.potęga < potęga:
					wektor_wyboru -= 5 * kierunek
	if wektor_wyboru == Vector2.ZERO:
		wektor_wyboru = Vector2(randi(), randi()).normalized()
#	$debug.position = wektor_wyboru
	return wektor_wyboru
