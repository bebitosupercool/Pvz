class_name PlantaDef
extends PlantaBase

@export var vidaex : float = 100

@export_group("Texturas por salud")
@export var textura_base : Texture2D = preload("res://assets/biznaga_base.png")
@export var textura_dano_medio : Texture2D = preload("res://assets/biznaga_dano_medio.png")
@export var textura_ultima_fase : Texture2D = preload("res://assets/biznaga_ultima_fase.png")

# Desfases en píxeles de la imagen, para que la base del cactus no se mueva
const OFFSET_BASE := Vector2(0, 0)
const OFFSET_DANO_MEDIO := Vector2(28.5, 67)
const OFFSET_ULTIMA_FASE := Vector2(14.5, 30)

@onready var sprite : Sprite2D = $Sprite2D

func _ready():
	ini_plant()
	vidamax += vidaex
	vida += vidaex
	actualizar_textura()

func recibir_ataque(cantidad : float):
	super(cantidad)              # lo que ya hace la base: restar vida, morir, parpadear
	if vida > 0:
		actualizar_textura()

func actualizar_textura():
	var porcentaje := vida / vidamax
	if porcentaje > 0.66:
		poner_fase(textura_base, OFFSET_BASE)
	elif porcentaje > 0.33:
		poner_fase(textura_dano_medio, OFFSET_DANO_MEDIO)
	else:
		poner_fase(textura_ultima_fase, OFFSET_ULTIMA_FASE)

func poner_fase(textura : Texture2D, desfase : Vector2):
	if textura == null:
		return
	sprite.texture = textura
	sprite.offset = desfase
