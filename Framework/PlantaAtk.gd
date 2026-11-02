class_name PlantaAtk
extends PlantaBase

#Estadisticas
@export var dpd : float = 20
@export var tpd : float = 1.0

@onready var timer = $Timer

func _ready():
	init_plant()
	timer.wait_time = tpd
	timer.timeout.connect(disparar)
	
func disparar():
	print("disparar")
