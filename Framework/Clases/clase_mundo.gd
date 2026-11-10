class_name Mundo
extends Node2D

const ZOMBIE_ESCENA = preload("res://Framework/Clases/Zombies/zombie.tscn")
const RUTA_FUENTE = "res://assets/fuentes/PinyonScript-Regular.ttf"

var enemigos_abatidos : int = 0
var juego_terminado : bool = false
#Sistema de oleadas
@onready var barra_progreso : TextureProgressBar = $CanvasLayer/BarraProgreso
@onready var etiqueta_oleada : Label = $CanvasLayer/EtiquetaOleada
@export var oleada_actual : int = 0
@export var cantidad_de_oleadas : int = 5
@export var enemigos_por_oleada : Array[int] = [2]
@export var tiempo_de_oleadas : Array[float] = [10.0]

var timer_oleada : Timer

#sistema de enemigos
var enemigos_totales : int = 0
var enemigos_totales_de_oleada: int = 0
var enemigos_actuales : int = 0

@export var nodo_lineas : Node2D

func inicializar_mundo():
	#Crear nuestro temporizador
	timer_oleada = Timer.new()
	timer_oleada.one_shot = true
	timer_oleada.wait_time = tiempo_de_oleadas[0]
	add_child(timer_oleada)

	#Conectar el temporizador con el inicio de cada oleada
	timer_oleada.timeout.connect(inicializar_oleada)
	timer_oleada.start()

	#Calcular enemigos totales
	for enemigos in enemigos_por_oleada:
		enemigos_totales += enemigos
	crear_barra_progreso()   

func inicializar_oleada():
	#Checar si hay nueva oleada
	if oleada_actual >= cantidad_de_oleadas:
		return

	#Verificar si existen la posicion del array
	if enemigos_por_oleada.size() < cantidad_de_oleadas or tiempo_de_oleadas.size() < cantidad_de_oleadas:
		return

	#Spawnear enemigos
	spawnear_enemigos(enemigos_por_oleada[oleada_actual])
	oleada_actual += 1

	#Hacer que espere a la siguiente oleada (solo si todavia hay)
	if oleada_actual < cantidad_de_oleadas:
		timer_oleada.wait_time = tiempo_de_oleadas[oleada_actual]
		timer_oleada.start()


func spawnear_enemigos(total : int):
	var lineas := nodo_lineas.get_children()
	for i in total:
		var zombie = ZOMBIE_ESCENA.instantiate()
		get_tree().current_scene.add_child(zombie)
		zombie.global_position = lineas.pick_random().global_position
		enemigos_actuales += 1
		await get_tree().create_timer(randf_range(0.5, 2.0)).timeout


func enemigo_abatido():
	enemigos_actuales -= 1
	enemigos_abatidos += 1
	actualizar_progreso()           # <-- antes del if de ganar
	if enemigos_abatidos >= enemigos_totales:
		ganar()

func ganar():
	terminar_partida("¡Ganaste!", "Jugar de nuevo")

func perder():
	terminar_partida("¡Perdiste!", "Reintentar")

func terminar_partida(texto : String, texto_boton : String):
	if juego_terminado:
		return
	juego_terminado = true
	mostrar_mensaje(texto, texto_boton)
	get_tree().paused = true

func mostrar_mensaje(texto : String, texto_boton : String):
	var capa := CanvasLayer.new()
	capa.process_mode = Node.PROCESS_MODE_ALWAYS   # sigue activo con el juego en pausa
	add_child(capa)

	var centro := CenterContainer.new()
	capa.add_child(centro)
	centro.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var columna := VBoxContainer.new()
	columna.add_theme_constant_override("separation", 30)
	centro.add_child(columna)

	var etiqueta := Label.new()
	etiqueta.text = texto
	etiqueta.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	if ResourceLoader.exists(RUTA_FUENTE):
		etiqueta.add_theme_font_override("font", load(RUTA_FUENTE))
	etiqueta.add_theme_font_size_override("font_size", 130)
	etiqueta.add_theme_color_override("font_color", Color(0.96, 0.9, 0.72))
	etiqueta.add_theme_color_override("font_outline_color", Color.BLACK)
	etiqueta.add_theme_constant_override("outline_size", 14)
	columna.add_child(etiqueta)

	var boton := Button.new()
	boton.text = texto_boton
	boton.add_theme_font_size_override("font_size", 36)
	boton.custom_minimum_size = Vector2(280, 70)
	boton.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	boton.pressed.connect(reiniciar)
	columna.add_child(boton)

func reiniciar():
	get_tree().paused = false          # si no, la escena nueva nace en pausa
	get_tree().reload_current_scene()

func crear_barra_progreso():
	barra_progreso.max_value = 100
	barra_progreso.value = 0
	etiqueta_oleada.text = "Progreso: 0%"

func actualizar_progreso():
	if enemigos_totales <= 0:
		return
	var porcentaje : float = float(enemigos_abatidos) / float(enemigos_totales) * 100.0
	barra_progreso.value = porcentaje
	etiqueta_oleada.text = "Progreso: %d%%" % int(porcentaje)
