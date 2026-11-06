extends Node
signal soles_actualizados(cantidad)

const SOLES_INICIALES := 100
var soles : int = SOLES_INICIALES

func _ready():
	await get_tree().create_timer(0.5).timeout
	soles_actualizados.emit(soles)

func agregar_soles(cantidad):
	soles += cantidad
	soles_actualizados.emit(soles)

func quitar_soles(cantidad):
	soles -= cantidad
	soles_actualizados.emit(soles)

func reiniciar():
	soles = SOLES_INICIALES
	soles_actualizados.emit(soles)
