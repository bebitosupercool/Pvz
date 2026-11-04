extends Node
signal soles_actualizados(cantidad)

var soles : int = 0

func agregar_soles(cantidad):
	soles += cantidad
	soles_actualizados.emit(soles)

func quitar_soles(cantidad):
	soles -= cantidad
	soles_actualizados.emit()
