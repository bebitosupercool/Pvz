extends Control



func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/niv_1.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/menu_opciones.tscn")
