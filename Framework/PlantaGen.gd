class_name PlantaGen
extends PlantaBase

#estadisticas
@export var Cantidadpitaya := 50.0
@export var Tiempogen := 10.0

@onready var timer = $Timer

func _ready():
	init_plant()
	timer.wait_time = Tiempogen
	timer.timeout.conect(generar)
func generar():
	print("Generar soles")
