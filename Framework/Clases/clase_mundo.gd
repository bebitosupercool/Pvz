class_name Mundo
extends Node2D

#Boton de pausa.
const MENU_OPCIONES = preload("res://Escenas/menu_opciones.tscn")
const ICONO_PAUSA = preload("res://assets/Boton_de_pausa.png")
const MENU_PRINCIPAL := "res://Escenas/Escenas.tscn"

var capa_pausa : CanvasLayer

# Ruta del nivel que sigue. Si esta vacia, es el ultimo nivel.
@export_file("*.tscn") var siguiente_nivel : String = ""

const ZOMBIE_ESCENA = preload("res://Framework/Clases/Zombies/zombie.tscn")
const RUTA_FUENTE = "res://assets/fuentes/PinyonScript-Regular.ttf"

#Variuables del sistema de lluvia de pitayas
const SOL_ESCENA = preload("res://Framework/objetos/Sol.tscn")   # verifica la ruta: clic derecho en Sol.tscn > Copiar ruta

const LLUVIA_X_MIN := 330.0
const LLUVIA_X_MAX := 1020.0
const LLUVIA_Y_MIN := 150.0    # altura donde se queda el sol (centro visible)
const LLUVIA_Y_MAX := 520.0
const LLUVIA_Y_INICIO := -40.0 # un poco arriba de la pantalla
@export var lluvia_tiempo_min := 8.0
@export var lluvia_tiempo_max := 12.0
@export var lluvia_valor := 50

var timer_lluvia : Timer

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
	iniciar_lluvia_soles()
	crear_boton_pausa()
		
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
	if siguiente_nivel != "":
		terminar_partida("¡Ganaste!", "Siguiente nivel", ir_a_siguiente_nivel)
	else:
		terminar_partida("¡Felicidades!", "Volver al menú", ir_al_menu)

func ir_al_menu():
	get_tree().paused = false            # si no, el menu carga congelado
	get_tree().change_scene_to_file(MENU_PRINCIPAL)
	
func perder():
	terminar_partida("¡Perdiste!", "Reintentar", reiniciar)

func terminar_partida(texto : String, texto_boton : String, accion : Callable):
	if juego_terminado:
		return
	juego_terminado = true
	mostrar_mensaje(texto, texto_boton, accion)
	get_tree().paused = true

func mostrar_mensaje(texto : String, texto_boton : String, accion : Callable):
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
	boton.pressed.connect(accion)        # antes era boton.pressed.connect(reiniciar)
	columna.add_child(boton)
	
func ir_a_siguiente_nivel():
	get_tree().paused = false            # si no, el nivel nuevo nace en pausa
	get_tree().change_scene_to_file(siguiente_nivel)
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
	var porcentaje : float = float(enemigos_abatidos) / float(enemigos_totales)   # de 0.0 a 1.0
	# El verde empieza al 5% de la imagen, asi que arrancamos ahi para que se note desde el primer zombie
	barra_progreso.value = lerp(5.0, 100.0, porcentaje)
	etiqueta_oleada.text = "Progreso: %d%%" % int(porcentaje * 100.0)
	
func iniciar_lluvia_soles():
	timer_lluvia = Timer.new()
	timer_lluvia.one_shot = true             
	add_child(timer_lluvia)                  
	timer_lluvia.timeout.connect(_caer_sol)
	timer_lluvia.start(5.0)                 

func _caer_sol():
	var sol : Sol = SOL_ESCENA.instantiate()
	sol.cae_del_cielo = true
	sol.cantidad_soles = lluvia_valor

	var desfase : Vector2 = sol.get_node("AnimatedSprite2D").position * sol.scale

	var x_visible := randf_range(LLUVIA_X_MIN, LLUVIA_X_MAX)
	var y_visible := randf_range(LLUVIA_Y_MIN, LLUVIA_Y_MAX)

	sol.position = Vector2(x_visible, LLUVIA_Y_INICIO) - desfase
	sol.destino_y = y_visible - desfase.y

	add_child(sol)  

	# reprogramar el siguiente con tiempo aleatorio
	timer_lluvia.start(randf_range(lluvia_tiempo_min, lluvia_tiempo_max))

#Creacion del boton pausa
func crear_boton_pausa():
	var boton := TextureButton.new()
	boton.texture_normal = ICONO_PAUSA
	boton.ignore_texture_size = true
	boton.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	boton.focus_mode = Control.FOCUS_NONE    

	# Anclado a la esquina superior derecha: se queda ahi aunque cambie la resolucion
	boton.anchor_left = 1.0
	boton.anchor_right = 1.0
	boton.anchor_top = 0.0
	boton.anchor_bottom = 0.0
	boton.offset_left = -72    
	boton.offset_right = -20
	boton.offset_top = 15
	boton.offset_bottom = 63   

	boton.pressed.connect(pausar)
	$CanvasLayer.add_child(boton)

func pausar():
	# No abrir si ya termino la partida o si el menu ya esta abierto
	if juego_terminado or capa_pausa != null:
		return
	capa_pausa = CanvasLayer.new()
	capa_pausa.layer = 100
	capa_pausa.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(capa_pausa)

	var menu := MENU_OPCIONES.instantiate()
	capa_pausa.add_child(menu)
	menu.tree_exited.connect(reanudar)

	get_tree().paused = true

func reanudar():
	if not is_inside_tree():     
		return
	get_tree().paused = false
	if capa_pausa != null:
		capa_pausa.queue_free()
		capa_pausa = null
