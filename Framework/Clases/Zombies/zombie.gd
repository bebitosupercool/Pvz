class_name Zombie
extends CharacterBody2D

#Estados
enum{CAMINAR, COMER, ABATIDO}
var direccion := -1
var estado_actual := CAMINAR
var estado_previo

#Estadisticas de salud
@export var salud_maxima : float = 100.0
var salud_actual : float = 100.0
#Estadisticas de ataque
@export var ataque : float = 20
@export var tiempo_de_ataque: float = 1.5
var planta_a_atacar : PlantaBase

#Movimiento
@export var velocidad : float = 15.0



@onready var animacion : AnimatedSprite2D = $AnimatedSprite2D
@onready var atacar_planta_timer = $Atacar
@onready var animacion_impacto: AnimationPlayer = $AnimacionImpacto


func _ready():
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
	salud_actual -= cantidad
	
	#Checar si tiene salud
	if salud_actual <= 0:
		queue_free()
		return 
	animacion_impacto.play("impacto")
