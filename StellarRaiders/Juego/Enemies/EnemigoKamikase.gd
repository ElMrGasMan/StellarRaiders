class_name EnemigoKamikase
extends EnemigoBase


enum STATE_AI {QUIETO, PERSECUCION}

export var vel_motor_maxima: float = 1000.0 

var ai_state_actual: int = STATE_AI.QUIETO
var vel_motor_actual: float = 0.0
var movimiento: Vector2 = Vector2.ZERO

onready var ray_cast_jugador: RayCast2D = $RayCastJugador


func _ready() -> void:
	set_process(true)
	player_state_controler(PLAYER_STATE.ALIVE)
	Events.emit_signal("objeto_minimapa_creado")


# warning-ignore:unused_argument
func _process(delta: float) -> void:
	if ray_cast_jugador.is_colliding():
		controlador_estados_ai(STATE_AI.PERSECUCION)
		set_process(false)


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	linear_velocity += dir_jugador.normalized() * vel_motor_actual * state.get_step()
	
	linear_velocity.x = clamp(linear_velocity.x, -vel_motor_maxima, vel_motor_maxima)
	linear_velocity.y = clamp(linear_velocity.y, -vel_motor_maxima, vel_motor_maxima)


func controlador_estados_ai(nuevo_estado: int) -> void:
	match nuevo_estado:
		STATE_AI.QUIETO:
			vel_motor_actual = 0.0
		
		STATE_AI.PERSECUCION:
			vel_motor_actual = vel_motor_maxima
		
		_:
			print("AI STATE ERROR")
	
	ai_state_actual = nuevo_estado
