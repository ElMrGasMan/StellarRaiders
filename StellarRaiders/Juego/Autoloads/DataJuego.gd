extends Node


var data_jugador: Jugador = null setget set_jugador_actual, get_jugador_actual


func _ready() -> void:
# warning-ignore:return_value_discarded
	Events.connect("player_destroyed", self, "_on_jugador_destruido")

func set_jugador_actual(jugador: Jugador) -> void:
	data_jugador = jugador


func get_jugador_actual() -> Jugador:
	return data_jugador


func _on_jugador_destruido(nave: NaveBase, _posicion, _explosiones) -> void:
	if nave is Jugador:
		data_jugador = null
