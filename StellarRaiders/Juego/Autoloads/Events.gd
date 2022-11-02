extends Node


# warning-ignore:unused_signal
signal shoot(proyectil)
# warning-ignore:unused_signal
signal player_destroyed(jugador, position, num_explosions)
# warning-ignore:unused_signal
signal shoot_meteor(position, direction, size)
# warning-ignore:unused_signal
signal destroy_meteor(position)
# warning-ignore:unused_signal
signal jugador_en_sector_peligroso(centro_camara, clase_peligro, cant_peligros)
# warning-ignore:unused_signal
signal base_destruida(posiciones_partes, base)
# warning-ignore:unused_signal
signal spawn_enemigo_orbital(enemigo)
# warning-ignore:unused_signal
signal comenzar_nivel()
# warning-ignore:unused_signal
signal terminar_nivel() 
# warning-ignore:unused_signal
signal entrar_zona_recarga(entrada)
# warning-ignore:unused_signal
signal cambio_numero_met(cant)
# warning-ignore:unused_signal
signal actualizar_tiempo(tiempo_restante)
# warning-ignore:unused_signal
signal actualizar_energia_laser(energia_maxima, energia_actual)
# warning-ignore:unused_signal
signal ocultar_energia_laser()
# warning-ignore:unused_signal
signal actualizar_energia_escudo(energia_maxima, energia_actual)
# warning-ignore:unused_signal
signal ocultar_energia_escudo()
# warning-ignore:unused_signal
signal objeto_minimapa_creado()
# warning-ignore:unused_signal
signal objeto_minimapa_destruido(obj)
# warning-ignore:unused_signal
signal nivel_completado()
# warning-ignore:unused_signal
signal misil_lanzado(misil_enemigo)
# warning-ignore:unused_signal
signal lanza_misiles_destruido(lanzador, cant_explosiones, pos)
