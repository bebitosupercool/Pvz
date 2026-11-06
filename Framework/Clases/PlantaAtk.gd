class_name PlantaAtk
extends PlantaBase

#Estadisticas
@export var dpd : float = 20
@export var tpd : float = 1.0

#disparo
@export var bala_instancia : PackedScene

@onready var timer = $Timer
@onready var marker_2d = $Marker2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready():
	ini_plant()
	timer.wait_time = tpd
	timer.timeout.connect(disparar)
	
	#prueba
	timer.start()
	
func hay_zombie_en_fila() -> bool:
	for z in get_tree().get_nodes_in_group("zombies"):
		var misma_fila : bool = abs(z.global_position.y - global_position.y) < 47.0
		var al_frente : bool = z.global_position.x > global_position.x
		if misma_fila and al_frente:
			return true
	return false

func disparar():
	if hay_zombie_en_fila():
		animation_player.play("shoot")
		
func spawnear_bala():
	var bala : Bala = bala_instancia.instantiate()
	get_tree().current_scene.add_child(bala)
	bala.global_position = marker_2d.global_position


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "shoot":
		animation_player.play("idle")
