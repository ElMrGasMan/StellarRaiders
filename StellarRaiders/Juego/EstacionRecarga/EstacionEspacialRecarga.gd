class_name EstacionEspacial
extends Node2D


export var energia_almacenada: float = 40.0
export var energia_dada_ratio: float = 0.5

var nave_jugador: Jugador = null
var jugador_en_zona_recarga: bool = false
var energia_escudo_maxima: float
var energia_laser_maxima: float 
var energia_laser_actual: float 
var energia_escudo_actual: float

onready var sfx_carga: AudioStreamPlayer = $SFX_Recarga
onready var sfx_vacia: AudioStreamPlayer2D = $SFX_EstacionVacia
onready var barra_energia: ProgressBar = $BarraEnergiaRestante


func _ready() -> void:
	barra_energia.max_value = energia_almacenada
	settear_energia_barra(energia_almacenada)


func _unhandled_input(event: InputEvent) -> void:
	if not puede_recargar(event):
		return
	
	if event.is_action("recarga_escudo"):
		energia_escudo_actual = nave_jugador.get_escudo().get_energia_escudo_actual()
		if not energia_escudo_actual == energia_escudo_maxima:
			nave_jugador.get_escudo().energia_control(energia_dada_ratio)
			energia_control()
	
	if event.is_action("recarga_laserbeam"):
		energia_laser_actual = nave_jugador.get_laser_beam().get_energia_actual_laser()
		if not energia_laser_actual == energia_laser_maxima:
			nave_jugador.get_laser_beam().energia_control(energia_dada_ratio)
			energia_control()
	
	if event.is_action_released("recarga_laserbeam"):
		Events.emit_signal("ocultar_energia_laser")
	
	elif event.is_action_released("recarga_escudo"):
		Events.emit_signal("ocultar_energia_escudo")


func _on_AreaColisionJugador_body_entered(body: Node) -> void:
	if body.has_method("destroy_player"):
		body.destroy_player()


func _on_AreaRecarga_body_entered(body: Node) -> void:
	if body is Jugador:
		nave_jugador = body
		jugador_en_zona_recarga = true
		Events.emit_signal("entrar_zona_recarga", true)
		energia_laser_maxima = nave_jugador.get_laser_beam().get_energia_maxima()
		energia_escudo_maxima = nave_jugador.get_escudo().get_energia_escudo()


# warning-ignore:unused_argument
func _on_AreaRecarga_body_exited(body: Node) -> void:
	jugador_en_zona_recarga = false
	Events.emit_signal("entrar_zona_recarga", false)


func puede_recargar(event: InputEvent) -> bool:
	var hace_input = event.is_action("recarga_escudo") or event.is_action("recarga_laserbeam")
	
	if hace_input and jugador_en_zona_recarga and energia_almacenada > 0.0:
		return true
	
	return false


func energia_control() -> void:
	if not sfx_carga.playing:
		sfx_carga.play()
	
	energia_almacenada -= energia_dada_ratio
	if energia_almacenada <= 0.0:
		sfx_vacia.play()
	
	settear_energia_barra(energia_almacenada)


func settear_energia_barra(energia_restante: float) -> void:
	barra_energia.value = energia_restante
