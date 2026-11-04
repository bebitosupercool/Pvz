extends Node2D

func _ready():
	#establecer las variables del game manager
	GameManager.mundo_actual = self_modulate
	GameManager.cursor_planta = $CursorPlanta
