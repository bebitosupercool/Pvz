class_name PlantaBase
extends Node2D

signal planta_muerta(celda : Vector2i)

#Caracteristicas
var vida :float = 300.0
@export var vidamax : float = 300.0

@export var celdaocup: Vector2i

@export var animacion : AnimationPlayer
@export var animacion_impacto : AnimationPlayer
func ini_plant():
	vida = vidamax

	if animacion != null:
		if animacion.has_animation("idle"):
			animacion.play("idle")

func recibir_ataque(cantidad : float):
	vida -= cantidad
	if vida <= 0:
		planta_muerta.emit(celdaocup)
		queue_free()
		return
	if animacion_impacto != null:
		animacion_impacto.play("impacto")
