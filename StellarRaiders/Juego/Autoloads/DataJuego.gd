extends Node


var data_jugador: Jugador = null setget set_jugador_actual, get_jugador_actual


func set_jugador_actual(jugador: Jugador) -> void:
	data_jugador = jugador


func get_jugador_actual() -> Jugador:
	return data_jugador
