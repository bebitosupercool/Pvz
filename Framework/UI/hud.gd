extends Control

@onready var cantidad_soles: Label = $PanelSoles/HBoxContainer/MarginContainer/Label

func _ready():
	Global.soles_actualizados.connect(actualizar_soles)

func actualizar_soles(soles: int):
	cantidad_soles.text = str(soles)
