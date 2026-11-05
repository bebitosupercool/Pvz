extends Mundo

@onready var celdas = $Celdas
@onready var cursor_planta = $CursorPlanta
@onready var plantas = $Plantas

const TAMANO_CELDA := Vector2(82, 94.5)
const ORIGEN_TABLERO := Vector2(347, 144)

func _ready():
	#establecer las variables del game manager
	GameManager.mundo_actual = self
	GameManager.cursor_planta = $CursorPlanta

	#Crear celdas
	crear_celdas()
	celdas.visible = false
	
	
	#Inicializar componente
	inicializar_mundo()
	
	
func mostrar_celdas(valor: bool):
	celdas.visible = valor
	
func crear_celdas():
	var celda_paquete := load("res://Framework/Clases/celda_planta.tscn")
	for x in range (0,9):
		for y in range (0,5):
			var nueva_celda = celda_paquete.instantiate()
			celdas.add_child(nueva_celda)
			nueva_celda.position = ORIGEN_TABLERO + Vector2(x, y) * TAMANO_CELDA
			nueva_celda.posicion_celda = Vector2i(x, y) 
