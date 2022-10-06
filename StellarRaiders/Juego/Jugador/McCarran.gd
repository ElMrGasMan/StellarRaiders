class_name Jugador
extends RigidBody2D


export var vel_movimiento: int = 35
export var vel_rotacion: int = 280

var empuje: Vector2 = Vector2.ZERO
var direc_rotacion: int = 0

onready var normal_weapon: NormalWeapon = $NormalWeapon


func _ready() -> void:
	pass 


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	apply_central_impulse(empuje.rotated(rotation))
	apply_torque_impulse(direc_rotacion * vel_rotacion)


func _process(delta: float) -> void:
	input_jugador()


func input_jugador() -> void:
	
	empuje = Vector2.ZERO
	
	if Input.is_action_pressed("mover_adelante"):
		empuje = Vector2(vel_movimiento, 0)
	
	elif Input.is_action_pressed("mover_atras"):
		empuje = Vector2(-vel_movimiento, 0)
	
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
