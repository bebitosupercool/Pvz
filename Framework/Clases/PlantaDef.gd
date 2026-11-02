class_name PlantaDef
extends PlantaBase

@export var vidaex : float = 100

func _ready():
	init_plant()
	vidamax += vidaex
	vida += vidaex
