class_name EnemigoTank
extends EnemigoBase


enum STATE_AI {IDLE, ATAQUE_QUIETO, ATAQUE_PERSECUCION, PERSECUCION}

export var vel_motor_maxima: float = 100.0 

var ai_state_actual: int = STATE_AI.IDLE
var vel_motor_actual: float = 0.0

onready var escudo_enemigo: Escudo = $Shield


func _ready() -> void:
	Events.emit_signal("objeto_minimapa_creado")
	escudo_enemigo.activate()
	player_state_controler(PLAYER_STATE.ALIVE)


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	linear_velocity += dir_jugador.normalized() * vel_motor_actual * state.get_step()
	
	linear_velocity.x = clamp(linear_velocity.x, -vel_motor_maxima, vel_motor_maxima)
	linear_velocity.y = clamp(linear_velocity.y, -vel_motor_maxima, vel_motor_maxima)


# warning-ignore:unused_argument
func _on_AreaDisparo_body_entered(body: Node) -> void:
	arma_anti_escudos.set_can_fire(true)
	controlador_estados_ai(STATE_AI.ATAQUE_PERSECUCION)


# warning-ignore:unused_argument
func _on_AreaDisparo_body_exited(body: Node) -> void:
	arma_anti_escudos.set_can_fire(false)
	controlador_estados_ai(STATE_AI.PERSECUCION)


# warning-ignore:unused_argument
func _on_AreaPerseguir_body_entered(body: Node) -> void:
	controlador_estados_ai(STATE_AI.ATAQUE_QUIETO)


# warning-ignore:unused_argument
func _on_AreaPerseguir_body_exited(body: Node) -> void:
	controlador_estados_ai(STATE_AI.ATAQUE_PERSECUCION)


func controlador_estados_ai(nuevo_estado: int) -> void:
	match nuevo_estado:
		STATE_AI.IDLE:
			arma_anti_escudos.set_is_firing(false)
			vel_motor_actual = 0.0
		
		STATE_AI.ATAQUE_QUIETO:
			arma_anti_escudos.set_is_firing(true)
			vel_motor_actual = 0.0
			
		STATE_AI.ATAQUE_PERSECUCION:
			arma_anti_escudos.set_is_firing(true)
			vel_motor_actual = vel_motor_maxima
		
		STATE_AI.PERSECUCION:
			arma_anti_escudos.set_is_firing(false)
			vel_motor_actual = vel_motor_maxima
		
		_:
			print("AI STATE ERROR")
	
	ai_state_actual = nuevo_estado
