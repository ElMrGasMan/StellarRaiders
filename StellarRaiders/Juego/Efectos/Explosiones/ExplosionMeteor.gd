class_name Explosion_Meteor
extends Node2D




func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "Destruccion":
		queue_free()
