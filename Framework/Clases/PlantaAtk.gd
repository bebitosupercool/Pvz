class_name PlantaAtk
extends PlantaBase

#Estadisticas
@export var dpd : float = 20
@export var tpd : float = 1.0

#disparo
var zombie_on_range := true
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
	
func disparar():
	#checar si la planta puede disparar
	if zombie_on_range:
		animation_player.play("shoot")
		
func spawnear_bala():
	var bala : Bala = bala_instancia.instantiate()
	get_tree().current_scene.add_child(bala)
	bala.global_position = marker_2d.global_position


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "shoot":
		animation_player.play("idle")
