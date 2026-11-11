class_name Sol
extends Area2D

var cantidad_soles := 50

# --- Datos para el sol que cae del cielo ---
var cae_del_cielo := false      # lo pone en true quien lo crea, ANTES de add_child
var destino_y := 0.0            # y (posicion del nodo) donde se detiene
const VELOCIDAD_CAIDA := 60.0   # unidades por segundo
const TIEMPO_EN_SUELO := 8.0    # segundos que espera a que lo recojan
const TIEMPO_DESVANECER := 1.0

var recogido := false           # evita sumar dos veces si hay dos clics en el mismo frame

func _ready():
	$AnimatedSprite2D.play("default")
	if cae_del_cielo:
		caer()                       # el sol del cielo se salta la animacion "start"
	else:
		$AnimationPlayer.play("start")   # el de la flor conserva su salto de 0.5 s

func caer():
	var distancia = destino_y - position.y
	var duracion = distancia / VELOCIDAD_CAIDA   # tiempo = distancia / velocidad
	var tween = create_tween()
	# 1) cae a velocidad constante
	tween.tween_property(self, "position:y", destino_y, duracion)
	# 2) espera en el suelo
	tween.tween_interval(TIEMPO_EN_SUELO)
	# 3) se desvanece (baja el alpha de modulate a 0)
	tween.tween_property(self, "modulate:a", 0.0, TIEMPO_DESVANECER)
	# 4) se elimina si nadie lo recogio
	tween.tween_callback(queue_free)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("click_izquierdo") and not recogido:
		recogido = true
		Global.agregar_soles(cantidad_soles)
		Sonido.reproducir(Sonido.SFX_SOL, 18.0)   # +18 dB porque el archivo es muy bajito
		queue_free()
