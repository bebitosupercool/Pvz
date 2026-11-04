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
	pass
	#if body is Zombie:
		##Spawnear el impacto de bala
		#var impacto = BALA_IMPACTO.instantiate()
		#get_tree().current_scene.add_child(impacto)
		#impacto.global_position = global_position
		##aplicarle el daño al zombie
		#queue_free()
