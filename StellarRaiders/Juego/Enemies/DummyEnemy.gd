class_name Enemies
extends Node2D


func _ready() -> void:
	pass


func _on_body_entered(body: Node) -> void:
	if body is Jugador:
		print("hola")
		body.destroy_player()
