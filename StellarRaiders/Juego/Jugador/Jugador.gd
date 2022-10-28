class_name Jugador
extends NaveBase


export var vel_movimiento: int = 35
export var vel_rotacion: int = 280
export var estela_maxima: int = 120

var empuje: Vector2 = Vector2.ZERO
var direc_rotacion: int = 0

onready var estela: Estela = $TrailStartingPoint/Trail2D
onready var estela2: Estela = $TrailStartingPoint2/Trail2D
##ARREGLAR ESTO CAPAZ SE PUEDEN PONER EN UN ARRAY
onready var player_shield: Shield = $Shield setget, get_escudo
onready var laser_beam: RayoLaser = $LaserBeam2D setget, get_laser_beam
onready var engine_sound: Motor = $SFX_Engine


func _ready() -> void:
	DataJuego.set_jugador_actual(self)


func get_laser_beam() -> RayoLaser:
	return laser_beam


func get_escudo() -> Shield:
	return player_shield


func input_jugador() -> void:
	if not input_is_active():
		return
	
	empuje = Vector2.ZERO
	
	if Input.is_action_pressed("mover_adelante"):
		empuje = Vector2(vel_movimiento, 0)
		engine_sound.sound_on()
	
	elif Input.is_action_pressed("mover_atras"):
		empuje = Vector2(-vel_movimiento, 0)
		engine_sound.sound_on()
	
	direc_rotacion = 0
	
	if Input.is_action_pressed("girar_sentido_horario"):
		direc_rotacion += 1
	
	elif Input.is_action_pressed("girar_sentido_antihorario"):
		direc_rotacion -= 1
	
	"Shooting"
	
	if Input.is_action_pressed("disparar_click_izquierdo"):
		normal_weapon.set_is_firing(true)
	
	elif Input.is_action_just_released("disparar_click_izquierdo"):
		normal_weapon.set_is_firing(false)


# warning-ignore:unused_argument
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	apply_central_impulse(empuje.rotated(rotation))
	apply_torque_impulse(direc_rotacion * vel_rotacion)


# warning-ignore:unused_argument
func _process(delta: float) -> void:
	input_jugador()


func _unhandled_input(event: InputEvent) -> void:
	if not input_is_active():
		return
	
	if event.is_action_pressed("disparar_laser_beam"):
		laser_beam.set_is_casting(true)
	
	elif event.is_action_released("disparar_laser_beam"):
		laser_beam.set_is_casting(false)
	
	
	if event.is_action_released("mover_adelante") or event.is_action_released("mover_atras"):
		engine_sound.sound_off()
	
	if event.is_action_pressed("mover_adelante"):
		estela.set_max_points(estela_maxima)
		estela2.set_max_points(estela_maxima)
	
	elif event.is_action_pressed("mover_atras"):
		estela.set_max_points(2)
		estela2.set_max_points(2)
	
	if event.is_action_pressed("activar_escudo") and not player_shield.get_is_activated():
		player_shield.activate()


func input_is_active() -> bool:
	if actual_state in  [PLAYER_STATE.DEAD, PLAYER_STATE.SPAWN]:
		return false
	
	return true


func desactivar_controles() -> void:
	player_state_controler(PLAYER_STATE.SPAWN)
	empuje = Vector2.ZERO
	engine_sound.sound_off()
	laser_beam.set_is_casting(false)
