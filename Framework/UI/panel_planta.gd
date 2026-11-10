class_name PanelPlanta
extends Panel

@export var textura : Texture2D
@export var tiempo_de_recuperacion : float = 7.5
@export var precio_soles : int = 50
@export var planta_a_colocar : PackedScene
@export var empieza_lista : bool = true

var en_recuperacion := false

@onready var sombra : ColorRect = $Sombra

func _ready():
	$TextureRect.texture = textura
	$TextureRect/Label.text = str(precio_soles)
	$Timer.wait_time = tiempo_de_recuperacion
	$Timer.one_shot = true
	$Timer.timeout.connect(_al_terminar_recuperacion)
	sombra.visible = false

	# Oscurecer la carta cuando no alcanzan los soles
	Global.soles_actualizados.connect(_al_cambiar_soles)
	_al_cambiar_soles(Global.soles)

	if not empieza_lista:
		iniciar_recuperacion()

func iniciar_recuperacion():
	en_recuperacion = true
	$Timer.start()
	sombra.visible = true
	sombra.anchor_top = 0.0     # la sombra cubre toda la carta
	var tween := create_tween()
	# el borde superior baja hasta tocar el fondo: la sombra desaparece
	tween.tween_property(sombra, "anchor_top", 1.0, tiempo_de_recuperacion)

func _al_terminar_recuperacion():
	en_recuperacion = false
	sombra.visible = false

func _al_cambiar_soles(soles : int):
	var alcanza := soles >= precio_soles
	$TextureRect.modulate = Color.WHITE if alcanza else Color(0.6, 0.6, 0.6)

func _on_gui_input(event: InputEvent) -> void:
	if en_recuperacion:
		return
	if event.is_action_pressed("click_izquierdo"):
		GameManager.planta_seleccionada(self)
