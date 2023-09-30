extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	for dinozaur in $Dinozaury.get_children():
		if dinozaur is Dinozaur:
			var siedlisko: Siedlisko = $Siedliska.get_children().pick_random()
			while siedlisko.zasiedlajacy_dinozaur != null:
				siedlisko = $Siedliska.get_children().pick_random()
			siedlisko.zasiedlajacy_dinozaur = dinozaur
			dinozaur.position = siedlisko.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	for siedlisko in $Siedliska.get_children():
		siedlisko.emit_signal("nowa_tura")
