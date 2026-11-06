extends CharacterBody2D

enum{CAMINAR, COMER, ABATIDO}
var direccion := -1
var estado_actual := CAMINAR
var estado_previo

var velocidad : float = 25.0

@onready var animacion = $AnimationPlayer


func _physics_process(delta):
	#Checar si el estado a cambiado
	if estado_actual != estado_previo:
		match estado_actual:
			CAMINAR:
				animacion.play("Caminar")
			COMER:
				animacion.play("Comer")
			ABATIDO:
				animacion.play("Abatido")
		estado_previo = estado_actual
	if estado_actual == CAMINAR:
		velocity.x = velocidad * direccion
		
	move_and_slide()
