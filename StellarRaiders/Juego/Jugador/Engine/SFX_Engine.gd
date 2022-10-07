class_name Motor
extends AudioStreamPlayer2D


export var tiempo_transicion: float = 0.9
export var volumen_apagado: float = -45

onready var volumen_tween: Tween = $Tween

var volumen_normal: float


func _ready() -> void:
	volumen_normal = volume_db
	volume_db = volumen_apagado


func sound_on() -> void:
	if not playing:
		play()
	
	efecto_transicion(volume_db, volumen_normal)


func sound_off() -> void:
	efecto_transicion(volume_db, volumen_apagado)


func efecto_transicion(desde_vol: float, hasta_vol: float) -> void:
# warning-ignore:return_value_discarded
	volumen_tween.interpolate_property(
		self, 
		"volume_db", 
		desde_vol, 
		hasta_vol, 
		tiempo_transicion, 
		Tween.TRANS_CUBIC,
		Tween.EASE_OUT
	)
# warning-ignore:return_value_discarded
	volumen_tween.start()
