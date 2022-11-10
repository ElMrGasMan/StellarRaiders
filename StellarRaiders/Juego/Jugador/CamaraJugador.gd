class_name CamaraJugador
extends CamaraJuego


export var variacion_zoom: float = 0.07
export var maximo_zoom: float = 2.4
export var minimo_zoom: float = 1.0


func _unhandled_input(event: InputEvent) -> void:
		if event.is_action_pressed("zoom_camara_acercar") and puede_zoomear:
			controlar_zoom(-variacion_zoom)
		
		elif event.is_action_pressed("zoom_camara_alejar") and puede_zoomear:
			controlar_zoom(variacion_zoom)


func controlar_zoom(modific_zoom: float) -> void:
	var zoom_x = clamp(zoom.x + modific_zoom, minimo_zoom, maximo_zoom)
	var zoom_y = clamp(zoom.y + modific_zoom, minimo_zoom, maximo_zoom)
	suavizar_zoom(zoom_x, zoom_y, 0.05)
