class_name Zombie
extends CharacterBody2D

#Estados
enum{CAMINAR, COMER, ABATIDO}
var direccion := -1
var estado_actual := CAMINAR
var estado_previo

#Estadisticas de salud
@export var salud_maxima : float = 200.0
var salud_actual : float = 200.0
#Estadisticas de ataque
@export var ataque : float = 20
@export var tiempo_de_ataque: float = 1.5
var planta_a_atacar : PlantaBase

#Movimiento
@export var velocidad : float = 100.0
const LIMITE_IZQUIERDO := 290.0


@onready var animacion : AnimatedSprite2D = $AnimatedSprite2D
@onready var atacar_planta_timer = $Atacar
@onready var animacion_impacto: AnimationPlayer = $AnimacionImpacto


func _ready():
	add_to_group("zombies")
	atacar_planta_timer.wait_time = tiempo_de_ataque
	atacar_planta_timer.connect("timeout",atacar_planta)
	
	#Establecer salud actual
	salud_actual = salud_maxima
	

func _physics_process(_delta):
	#Checar si el estado a cambiado
	if estado_actual != estado_previo:
		match estado_actual:
			CAMINAR:
				animacion.play("caminar")
			COMER:
				animacion.play("comer")
			ABATIDO:
				animacion.play("abatido")
		estado_previo = estado_actual
		
	#poner la velocidad
	if estado_actual == CAMINAR:
		velocity.x = velocidad * direccion
	else:
		velocity.x = 0
	move_and_slide()
	if global_position.x < LIMITE_IZQUIERDO:
		GameManager.mundo_actual.perder()

func _on_detector_area_entered(area):
	estado_actual = COMER
	planta_a_atacar = area.get_parent()
	atacar_planta()
	
func _on_detector_area_exited(area):
	estado_actual = CAMINAR
	planta_a_atacar = null
	atacar_planta_timer.stop()


func atacar_planta():
	#verificar si la planta es valida
	if planta_a_atacar != null:
		planta_a_atacar.recibir_ataque(ataque)
		atacar_planta_timer.start()
		print("ATACANDO PLANTA")
			
		
		
func recibir_ataque(cantidad : float):
	if salud_actual <= 0:        # ya estaba muerto, no contar dos veces
		return
	salud_actual -= cantidad

	if salud_actual <= 0:
		GameManager.mundo_actual.enemigo_abatido()   # avisar al mundo
		queue_free()
		return
	animacion_impacto.play("impacto")
