class_name PlantaBase
extends Node2D

#Caracteristicas
var vida :float = 300.0
@export var vidamax : float = 300.0

@export var celdaocup: Vector2

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
		queue_free()
		return
	if animacion_impacto != null:
		animacion_impacto.play("impacto")
