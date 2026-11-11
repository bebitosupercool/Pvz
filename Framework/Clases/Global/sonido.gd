extends Node

# preload carga el audio al iniciar el juego, para que no haya tirones al sonar.
const SFX_SOL      = preload("res://assets/sonidos/AgarrarDinero.mp3")
const SFX_DISPARO  = preload("res://assets/sonidos/lanzamiento.mp3")
const SFX_IMPACTO  = preload("res://assets/sonidos/plantar.mp3")
const SFX_PLANTAR  = preload("res://assets/sonidos/plantar.mp3")

# stream      : el audio a reproducir
# volumen_db  : volumen en decibeles. 0 = original, +6 = el doble de fuerte, -6 = la mitad
# desde       : segundo del archivo donde empieza (para saltarse silencios o elegir un trozo)
# duracion    : cuantos segundos suena como maximo (0 = hasta que termine solo)
# pitch       : velocidad/tono. 1.0 = normal, 1.5 = mas agudo y rapido, 0.8 = mas grave
func reproducir(stream: AudioStream, volumen_db := 0.0, desde := 0.0, duracion := 0.0, pitch := 1.0) -> void:
	var p := AudioStreamPlayer.new()      # crea un reproductor nuevo cada vez: permite sonidos superpuestos
	p.stream = stream
	p.volume_db = volumen_db
	p.pitch_scale = pitch
	add_child(p)                          # debe estar en el arbol para sonar
	p.play(desde)                         # play(posicion) empieza desde ese segundo
	p.finished.connect(p.queue_free)      # al terminar solo, se elimina
	if duracion > 0.0:
		# create_timer es un temporizador de un solo uso, sin necesidad de nodo
		get_tree().create_timer(duracion).timeout.connect(func():
			if is_instance_valid(p):      # puede haberse borrado ya al terminar el audio
				p.queue_free())
