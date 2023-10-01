class_name Dinozaur
extends Node

var aktualne_siedlisko: Siedlisko
var potęga:= 0


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.label_settings.font_color = Color(
		randf_range(0,1),
		randf_range(0,1),
		randf_range(0,1)
		)

