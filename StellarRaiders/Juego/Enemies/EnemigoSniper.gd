class_name EnemigoSniper
extends EnemigoBase

enum STATE_AI {IDLE, ATAQUE_QUIETO, ESCAPE}

export var vel_motor_maxima: float = 1000.0 

onready var arma_sniper: NormalWeapon1Proyectil = $NormalWeapon1Proyectil
onready var ray_cast_sniper: RayCast2D = $RayCastDisparo

var ai_state_actual: int = STATE_AI.ATAQUE_QUIETO
var vel_motor_actual: float = 0.0


func _ready() -> void:
	arma_sniper.set_can_fire(true)
	player_state_controler(PLAYER_STATE.ALIVE)
	Events.emit_signal("objeto_minimapa_creado")


# warning-ignore:unused_argument
func _process(delta: float) -> void:
	if ray_cast_sniper.is_colliding():
		arma_sniper.set_is_firing(true)
	else:
		arma_sniper.set_is_firing(false)


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	linear_velocity += -(dir_jugador.normalized()) * vel_motor_actual * state.get_step()
	
	linear_velocity.x = clamp(linear_velocity.x, -vel_motor_maxima, vel_motor_maxima)
	linear_velocity.y = clamp(linear_velocity.y, -vel_motor_maxima, vel_motor_maxima)
	
	print(linear_velocity)
	
	if dir_jugador.x <= -1200.0:
		controlador_estados_ai(STATE_AI.ATAQUE_QUIETO)
		linear_velocity = Vector2.ZERO


# warning-ignore:unused_argument
func _on_AreaJugadorCerca_body_entered(body: Node) -> void:
	controlador_estados_ai(STATE_AI.ESCAPE)


func controlador_estados_ai(nuevo_estado: int) -> void:
	match nuevo_estado:
		STATE_AI.IDLE:
			vel_motor_actual = 0.0
		
		STATE_AI.ATAQUE_QUIETO:
			arma_sniper.set_can_fire(true)
			set_process(true)
			vel_motor_actual = 0.0
			
		STATE_AI.ESCAPE:
			arma_sniper.set_can_fire(false)
			set_process(false)
			vel_motor_actual = vel_motor_maxima
		
		_:
			print("AI STATE ERROR")
	
	ai_state_actual = nuevo_estado
