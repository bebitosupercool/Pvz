class_name PlantaBase
extends Node2D

#Caracteristicas
var vida :float = 300.0
@export var vidamax : float = 300.0

@export var celdaocup: Vector2

func init_plant():
	vida = vidamax
