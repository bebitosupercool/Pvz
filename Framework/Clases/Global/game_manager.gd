extends Node2D

var mundo_actual : Mundo
var cursor_planta : CursorPlanta
var hud : HUD
var celda_valida : bool = false
var mostrar_cursor_planta : bool = false

var plantas_colocadas : Dictionary = {}
var panel_planta_actual : PanelPlanta
var posicion_actual : Vector2i
var celda_actual: CeldaPlanta

func planta_seleccionada(panel_planta : PanelPlanta):
	if panel_planta.en_recuperacion or Global.soles < panel_planta.precio_soles:
		return
	if Global.soles < panel_planta.precio_soles:
		return
	#Actualizar la variable
	panel_planta_actual = panel_planta
	
	mostrar_cursor_planta = true      
	#Mostrar el cursor                   
	cursor_planta.actualizar_visuales(panel_planta)
	cursor_planta.visible = true
	mundo_actual.mostrar_celdas(true)
	hud.activar_boton_cancelar(true)

func cancelar_seleccion():
	mostrar_cursor_planta = false
	panel_planta_actual = null
	if cursor_planta != null:
		cursor_planta.visible = false

func _process(_delta: float) -> void:
	if cursor_planta != null and mostrar_cursor_planta:
		# Mejor pedirle la posición al propio cursor (usa su canvas)
		cursor_planta.global_position = cursor_planta.get_global_mouse_position()

func _unhandled_input(event: InputEvent) -> void:
	# Como en el original: clic derecho cancela la selección
	if mostrar_cursor_planta and event.is_action_pressed("click_derecho"):
		cancelar_seleccion()

func actualizar_celda_actual(pos : Vector2i, celda : CeldaPlanta):
	cursor_planta.establecer_celda_valida(not plantas_colocadas.has(pos))
	posicion_actual = pos
	celda_actual = celda

func intentar_colocar_planta():
	
	if panel_planta_actual and not plantas_colocadas.has(posicion_actual):
		
		#Crear instancia de la planta a colocar 
		var nueva_planta = panel_planta_actual.planta_a_colocar.instantiate()
		
		nueva_planta.celdaocup = posicion_actual
		nueva_planta.planta_muerta.connect(_on_planta_muerta)
		
		#Agregar mi planta al nodo del mundo 
		mundo_actual.plantas.add_child(nueva_planta)
		
		#Colocarle la posicion global
		nueva_planta.global_position = celda_actual.global_position
		
		#Agregar la planta a mi diccionario
		plantas_colocadas[posicion_actual] = nueva_planta
		
		#Quitarle los soles
		Global.quitar_soles(panel_planta_actual.precio_soles)
		panel_planta_actual.iniciar_recuperacion()
		
		#restablecer las variables
		panel_planta_actual = null
		celda_actual = null 
		mostrar_cursor_planta = false
		mundo_actual.mostrar_celdas(false)
		cursor_planta.actualizar_visuales(null)
		hud.activar_boton_cancelar(false)
		
func cancelar_planta():
	
	#restablecer las variables
	panel_planta_actual = null
	celda_actual = null 
	mostrar_cursor_planta = false
	mundo_actual.mostrar_celdas(false)
	cursor_planta.actualizar_visuales(null)
	hud.activar_boton_cancelar(false)
	
func reiniciar_estado():
	plantas_colocadas.clear()
	panel_planta_actual = null
	celda_actual = null
	mostrar_cursor_planta = false
	posicion_actual = Vector2i.ZERO
	
func _on_planta_muerta(celda : Vector2i):
	plantas_colocadas.erase(celda)
