extends CharacterBody2D

enum{CAMINAR, COMER, ABATIDO}
var direccion := -1
var estado_actual := CAMINAR
var estado_previo

@export var ataque : float = 20
@export var velocidad : float = 15.0
@export var tiempo_de_ataque: float = 1.5

var planta_a_atacar = PlantaBase
@onready var animacion : AnimatedSprite2D = $AnimatedSprite2D
@onready var atacar_planta_timer = $AtacarPlantaTimer


func _ready():
	atacar_planta_timer.wait_time = tiempo_de_ataque
	atacar_planta_timer.connect("timeout",atacar_planta)


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
		
		
		
		
		
		
