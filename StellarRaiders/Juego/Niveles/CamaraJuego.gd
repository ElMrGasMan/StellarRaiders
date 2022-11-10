class_name CamaraJuego
extends Camera2D


var zoom_original: Vector2 
var puede_zoomear: bool = true setget set_puede_hacer_zoom

onready var tween_zoom: Tween = $TweenZoom


func _ready() -> void:
	zoom_original = zoom


func set_puede_hacer_zoom(puede_hacerlo: bool) -> void:
	puede_zoomear = puede_hacerlo


func suavizar_zoom(nuevo_zoom_x: float, nuevo_zoom_y: float, tiempo_transicion: float) -> void:
# warning-ignore:return_value_discarded
	tween_zoom.interpolate_property(
		self,
		"zoom",
		zoom,
		Vector2(nuevo_zoom_x, nuevo_zoom_y),
		tiempo_transicion,
		Tween.TRANS_ELASTIC,
		Tween.EASE_IN_OUT
	)
# warning-ignore:return_value_discarded
	tween_zoom.start()


func devolver_zoom() -> void:
	puede_zoomear = false
	suavizar_zoom(zoom_original.x, zoom_original.y, 0.8)
