class_name Explosion_Meteor
extends Node2D


onready var animaciones: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animaciones.play(elegir_explosion_random())


# warning-ignore:unused_argument
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	queue_free()


func elegir_explosion_random() -> String:
	randomize()
	var num_anim: int = animaciones.get_animation_list().size() - 1
	var indice_anim: int = randi() % num_anim + 1
	var lista_anim: Array = animaciones.get_animation_list()
	
	return lista_anim[indice_anim]
