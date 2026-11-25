class_name PanelPala
extends TextureButton

# Imagen que sigue al mouse. Si la dejas vacia, usa la misma del boton.
@export var textura_cursor : Texture2D

func _ready():
	pressed.connect(_al_presionar)     # "pressed" se emite al soltar el clic sobre el boton

func _al_presionar():
	var textura : Texture2D = textura_cursor if textura_cursor != null else texture_normal
	GameManager.pala_seleccionada(textura)
