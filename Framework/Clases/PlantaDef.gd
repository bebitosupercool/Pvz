class_name PlantaDef
extends PlantaBase

@export var vidaex : float = 100

func _ready():
	ini_plant()
	vidamax += vidaex
	vida += vidaex
