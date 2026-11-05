class_name CursorPlanta
extends Node2D

# Ancho (en píxeles) que quieres que tenga la planta pegada al mouse
@export var ancho_cursor : float = 80.0

@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	visible = false

func actualizar_visuales(panel_planta : PanelPlanta):
	if panel_planta == null:
		sprite.texture = null
		return
	if panel_planta.textura == null:
		return
	sprite.texture = panel_planta.textura
	# factor = ancho que quiero / ancho real de la imagen
	var factor : float = ancho_cursor / sprite.texture.get_width()
	sprite.scale = Vector2(factor, factor)

func establecer_celda_valida(valor : bool):
	if valor:
		sprite.self_modulate = Color(1.0, 1.0, 1.0, 0.8)
	else:
		sprite.self_modulate = Color(1.0, 0.07, 0.07, 0.8)
