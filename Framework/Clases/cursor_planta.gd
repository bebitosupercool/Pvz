extends Node2D

@onready var sprite: Sprite2D = $Sprite2D


func actualizar_visuales(panel_planta : PanelPlanta):
	sprite.texture = panel_planta.textura

func establecer_celda_valida(valor : bool):
	if valor:
		sprite.self_modulate = Color(1.0, 1.0, 1.0, 0.5)
	else:
		sprite.self_modulate = Color(1.0, 0.07, 0.07, 0.5)
