class_name PanelPala
extends Control

# Imagen que sigue al mouse. Si la dejas vacia, usa la del TextureRect de la pala.
@export var textura_cursor : Texture2D

func _ready():
	mouse_filter = Control.MOUSE_FILTER_STOP     # asegura que este nodo reciba los clics

# _gui_input es una funcion especial de los Control: Godot la llama sola cuando
# llega un evento de mouse o teclado sobre este nodo. No hace falta conectar ninguna señal.
func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click_izquierdo"):
		var textura : Texture2D = textura_cursor
		if textura == null:
			textura = $TextureRect.texture       # la misma imagen que ves en el boton
		GameManager.pala_seleccionada(textura)
