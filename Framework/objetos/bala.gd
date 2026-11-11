class_name Bala
extends Area2D

var speed := 100.0
const BALAZO_SHEET = preload("uid://ckwxkf7jkfa25")
const BALA_IMPACTO = preload("uid://b2ca7aixdgdh0")


func _physics_process(delta):
	position.x += speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	queue_free()


func _on_area_entered(area):
	var target_zombie = area.get_parent()
	if target_zombie is Zombie:
		#Spawnear el impacto de bala
		var impacto = BALA_IMPACTO.instantiate()
		get_tree().current_scene.add_child(impacto)
		impacto.global_position = global_position
		Sonido.reproducir(Sonido.SFX_IMPACTO, -2.0, 0.0, 0.3, 1.5)
		#aplicarle el daño al zombie
		target_zombie.recibir_ataque(25)
		#Eliminar bala
		queue_free()
