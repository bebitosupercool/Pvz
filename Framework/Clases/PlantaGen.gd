class_name PlantaGen
extends PlantaBase

#estadisticas
@export var Cantidadpitaya := 50.0
@export var Tiempogen := 10.0

#Referencias
@onready var timer = $Timer
@export var escena_sol : PackedScene

func _ready():
	ini_plant()
	
	#configurar timer
	timer.wait_time = Tiempogen
	timer.timeout.connect(generar)
	
	#iniciar temp
	timer.start()
	
func generar():

	#checar si la escena del sol es valida
	if escena_sol != null:
		#Creamos una instancia en nuestra escena
		var nuevo_Sol : Sol = escena_sol.instantiate()
		nuevo_Sol.cantidad_soles = Cantidadpitaya
		get_tree().current_scene.add_child(nuevo_Sol)
		#Le asignamos la ubicacion
		var posicion_aleatoria = randf_range(-15, 15)
		nuevo_Sol.global_position = self.global_position
		nuevo_Sol.global_position.x += posicion_aleatoria
