class_name Hud
extends CanvasLayer


onready var animaciones: AnimationPlayer = $FadeCanvas/AnimationPlayer
onready var contenedor_recarga: ContenedorInfo = $ContenedorInfoRecarga
onready var contenedor_meteoritos: ContenedorInfo = $ContenedorInfoMeteoritos
onready var contenedor_tiempo_restante: ContenedorInfo = $ContenedorInfoTiempo
onready var contenedor_energia_laser: ContenedorInfoEnergia = $ContenedorInfoEnergiaLaser
onready var contenedor_energia_escudo: ContenedorInfoEnergia = $ContenedorInfoEnergiaEscudo


func _ready() -> void:
	conectar_signals()


func conectar_signals() -> void:
	# warning-ignore:return_value_discarded
	Events.connect("comenzar_nivel", self, "desaparecer")
# warning-ignore:return_value_discarded
	Events.connect("terminar_nivel", self, "aparecer")
# warning-ignore:return_value_discarded
	Events.connect("entrar_zona_recarga", self, "_on_entrar_zona_recarga")
# warning-ignore:return_value_discarded
	Events.connect("cambio_numero_met", self, "_on_cambiar_num_met")
# warning-ignore:return_value_discarded
	Events.connect("actualizar_tiempo", self, "_on_actualizar_tiempo")
# warning-ignore:return_value_discarded
	Events.connect("actualizar_energia_laser", self, "_on_actualizar_energia_laser")
# warning-ignore:return_value_discarded
	Events.connect("ocultar_energia_laser", contenedor_energia_laser, "invisible")
# warning-ignore:return_value_discarded
	Events.connect("actualizar_energia_escudo", self, "_on_actualizar_energia_escudo")
# warning-ignore:return_value_discarded
	Events.connect("ocultar_energia_escudo", contenedor_energia_escudo, "invisible")
# warning-ignore:return_value_discarded
	Events.connect("player_destroyed", self, "_on_player_destroyed")


func aparecer() -> void:
	animaciones.play("Aparecer")


func desaparecer() -> void:
	animaciones.play_backwards("Aparecer")


func _on_entrar_zona_recarga(en_zona: bool) -> void:
	if en_zona:
		contenedor_recarga.invisible_visible()
	
	else:
		contenedor_recarga.visible_invisible()


func _on_cambiar_num_met(cant: int) -> void:
	contenedor_meteoritos.invisible_visible()
	contenedor_meteoritos.modificar_texto("Meteoritos \n restantes \n {cant}".format({"cant": cant}))


func _on_actualizar_tiempo(tiempo_restante: int) -> void:
# warning-ignore:narrowing_conversion
	var minutos_restantes: int = floor(tiempo_restante * 0.016666666666667)
	var segundos_restantes: int = tiempo_restante % 60
	
	contenedor_tiempo_restante.modificar_texto("Tiempo \n Restante: \n %02d:%02d" % [minutos_restantes, segundos_restantes])
	
	if tiempo_restante % 10 == 0:
		contenedor_tiempo_restante.invisible_visible()
	
	if tiempo_restante == 11:
		contenedor_tiempo_restante.set_auto_ocultar(false)
	
	elif tiempo_restante == 0:
		contenedor_tiempo_restante.invisible()


func _on_actualizar_energia_laser(energia_maxima:float, energia_actual: float) -> void:
	contenedor_energia_laser.visiblee()
	contenedor_energia_laser.actualizar_medidor(energia_maxima, energia_actual)


func _on_actualizar_energia_escudo(energia_maxima:float, energia_actual: float) -> void:
	contenedor_energia_escudo.visiblee()
	contenedor_energia_escudo.actualizar_medidor(energia_maxima, energia_actual)


func _on_player_destroyed(nave: NaveBase, _pos, _expl) -> void:
	if nave is Jugador:
		get_tree().call_group("contenedor_info", "set_esta_visible", false)
		get_tree().call_group("contenedor_info", "invisible")
