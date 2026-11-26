extends Control

# Este menu se agrega como hijo del nivel que se esta jugando (Mundo.perder()),
# por eso la "escena actual" siempre es ese nivel y no el menu.


# Boton "Salir al menu"
func _on_button_2_pressed() -> void:
	get_tree().paused = false            # si no, el menu principal carga congelado
	get_tree().change_scene_to_file("res://Escenas/Escenas.tscn")


# Boton "Reintentar": reinicia solo el nivel en el que estas jugando
func _on_button_pressed() -> void:
	get_tree().paused = false            # si no, el nivel reiniciado nace en pausa
	get_tree().reload_current_scene()
