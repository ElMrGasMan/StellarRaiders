class_name PuertaL
extends Node2D


onready var animaciones: AnimationPlayer = $AnimationPlayer
onready var detector_jugador_colisionador: CollisionShape2D = $DetectorJugador/CollisionShape2D
onready var tween: Tween = $Tween


func _ready() -> void:
	Events.emit_signal("objeto_minimapa_creado")


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "Spawning":
		animaciones.play("Activado")
		detector_jugador_colisionador.set_deferred("disabled", false)


func _on_DetectorJugador_body_entered(body: Node) -> void:
	detector_jugador_colisionador.set_deferred("disabled", true)
	animaciones.play("SuperActivado")
	body.desactivar_controles()
	atraer_jugador(body)


func _on_Tween_tween_all_completed() -> void:
	print("Muy bien master, pasaste de nivel, ahora te queda mas tortura por sobrellevar")


func atraer_jugador(body: Node) -> void:
# warning-ignore:return_value_discarded
	tween.interpolate_property(
		body, 
		"global_position", 
		body.global_position, 
		global_position, 
		4.0, 
		Tween.TRANS_ELASTIC, 
		Tween.EASE_OUT
		)
	
# warning-ignore:return_value_discarded
	tween.start()
