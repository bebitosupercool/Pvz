extends Control

const MENU_OPCIONES := preload("res://Escenas/menu_opciones.tscn")
var menu_actual: Node = null


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/tuto.tscn")


func _on_options_pressed() -> void:
	if menu_actual != null:
		return  # ya está abierto
	menu_actual = MENU_OPCIONES.instantiate()
	add_child(menu_actual)
	menu_actual.tree_exited.connect(func(): menu_actual = null)
