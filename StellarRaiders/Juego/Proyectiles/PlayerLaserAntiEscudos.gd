class_name ProyectilAntiEscudos
extends Proyectil


onready var animaciones: AnimationPlayer = $AnimationPlayer


func damage(other_body: CollisionObject2D) -> void:
	
	if other_body is Escudo:
		damages *= 1.5
	
	else: 
		damages *= 0.5
	
	.damage(other_body)
