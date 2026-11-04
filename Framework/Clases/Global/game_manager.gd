extends Node2D

var mundo_actual : Node2D
var cursor_planta : Node2D
var celda_valida : bool = false
var mostrar_cursor_planta : bool = false

var plantas_colocadas : Dictionary = {}
var panel_planta_actual : PanelPlanta

func planta_seleccionada(panel_planta : PanelPlanta):
	if Global.soles < panel_planta.precio_soles:
		return
	#actualizar la variable
	panel_planta_actual = panel_planta
	
func _physics_process(delta: float) -> void:
	if cursor_planta != null and mostrar_cursor_planta:
		cursor_planta.global_position = get_global_mouse_position()
	
	print("Actualizar la info del cursor")
	#mostrar el cursor
	if mostrar_cursor_planta:
		print("mostrar el cursor")
		mostrar_cursor_planta = true
		cursor_planta.actualizar_visuales(panel_planta_actual)
	
func actualizar_celda_actual(pos : Vector2i):
	pass

func intentar_colocar_planta():
	pass
