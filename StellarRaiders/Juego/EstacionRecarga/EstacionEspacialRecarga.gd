class_name EstacionEspacial
extends Node2D


export var energia_almacenada: float = 40.0
export var energia_dada_ratio: float = 0.5

onready var sfx_carga: AudioStreamPlayer = $SFX_Recarga
onready var sfx_vacia: AudioStreamPlayer2D = $SFX_EstacionVacia

var nave_jugador: Jugador = null
var jugador_en_zona_recarga: bool = false


func _unhandled_input(event: InputEvent) -> void:
	if not puede_recargar(event):
		return
	
	energia_control()
	
	if event.is_action_pressed("recarga_escudo"):
		nave_jugador.get_escudo().energia_control(energia_dada_ratio)
	
	elif event.is_action_pressed("recarga_laserbeam"):
		nave_jugador.get_laser_beam().energia_control(energia_dada_ratio)


func _on_AreaColisionJugador_body_entered(body: Node) -> void:
	if body.has_method("destroy_player"):
		body.destroy_player()


func _on_AreaRecarga_body_entered(body: Node) -> void:
	if body is Jugador:
		nave_jugador = body
	
	jugador_en_zona_recarga = true
	body.set_gravity_scale(0.1)


func _on_AreaRecarga_body_exited(body: Node) -> void:
	body.set_gravity_scale(0.0)
	jugador_en_zona_recarga = false


func puede_recargar(event: InputEvent) -> bool:
	var hace_input = event.is_action("recarga_escudo") or event.is_action("recarga_laserbeam")
	
	if hace_input and jugador_en_zona_recarga and energia_almacenada > 0.0:
		if not sfx_carga.playing:
			sfx_carga.play()
		
		return true
	
	return false


func energia_control() -> void:
	energia_almacenada -= energia_dada_ratio
	
	if energia_almacenada <= 0.0:
		sfx_vacia.play()
