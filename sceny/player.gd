extends Dinozaur


func przetwórz_klickables() -> Array:
	var klickables: Array = [aktualne_siedlisko]
	aktualne_siedlisko.get_node("AlertKliknięcia").visible = true
	aktualne_siedlisko.get_node("AlertKliknięcia").disabled = false
	print(aktualne_siedlisko.połączenia)
	for klikable in aktualne_siedlisko.połączenia:
		klikable.get_node("AlertKliknięcia").visible = true
		klikable.get_node("AlertKliknięcia").disabled = false
		klickables.append(klikable)
	return klickables
