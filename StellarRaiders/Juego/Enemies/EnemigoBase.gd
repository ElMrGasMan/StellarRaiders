class_name EnemigoBase
extends NaveBase


var jugador_objetivo: Jugador = null
var dir_jugador: Vector2 
var frame_control: int = 0


func _ready() -> void:
	jugador_objetivo = DataJuego.get_jugador_actual()
# warning-ignore:return_value_discarded
	Events.connect("player_destroyed", self, "_on_jugador_destruido")


# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	frame_control += 1
	
	if frame_control % 3 == 0:
		mirar_al_jugador()


func _on_body_entered(body: Node) -> void:
	._on_body_entered(body)
	
	if body is Jugador:
		body.destroy_player()
		destroy_player()


func mirar_al_jugador() -> void:
	if jugador_objetivo:
		dir_jugador = jugador_objetivo.global_position - global_position
		rotation = dir_jugador.angle()


func _on_jugador_destruido(nave: NaveBase, _posicion, _explosiones) -> void:
	if nave is Jugador:
		jugador_objetivo = null
	
	if nave.is_in_group("minimapa"):
		Events.emit_signal("objeto_minimapa_destruido", nave)
