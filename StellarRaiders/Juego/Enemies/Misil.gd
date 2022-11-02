class_name Misil
extends EnemigoBase


export var vel_misil: float = 1000.0 

var movimiento: Vector2 = Vector2.ZERO
var lanza_misiles_duenio: Node2D


func _ready() -> void:
	player_state_controler(PLAYER_STATE.ALIVE)
	Events.emit_signal("objeto_minimapa_creado")
# warning-ignore:return_value_discarded
	Events.connect("lanza_misiles_destruido", self, "_on_lanza_misiles_destruido")


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	linear_velocity += dir_jugador.normalized() * vel_misil * state.get_step()
	
	linear_velocity.x = clamp(linear_velocity.x, -vel_misil, vel_misil)
	linear_velocity.y = clamp(linear_velocity.y, -vel_misil, vel_misil)


func crear_misil(posicion: Vector2, rotacion: float, lanza_misiles: Node2D) -> void:
	global_position = posicion
	rotation = rotacion
	lanza_misiles_duenio = lanza_misiles


func _on_lanza_misiles_destruido(lanza_misiles: Node2D, _cant, _pos) -> void:
	if lanza_misiles == lanza_misiles_duenio:
		destroy_player()
