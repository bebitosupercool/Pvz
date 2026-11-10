extends HSlider

func _ready():
	min_value = 0.0
	max_value = 1.0
	step = 0.01
	value = db_to_linear(AudioServer.get_bus_volume_db(0))   # muestra el volumen actual
	value_changed.connect(_on_volumen_cambiado)

func _on_volumen_cambiado(valor : float):
	AudioServer.set_bus_volume_db(0, linear_to_db(valor))
	AudioServer.set_bus_mute(0, valor <= 0.001)              # silencio total en 0
