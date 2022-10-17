class_name Jugador
extends RigidBody2D


enum PLAYER_STATE {SPAWN, ALIVE, INVINCIBLE, DEAD}

export var vel_movimiento: int = 35
export var vel_rotacion: int = 280
export var estela_maxima: int = 120

var empuje: Vector2 = Vector2.ZERO
var direc_rotacion: int = 0
var actual_state: int = PLAYER_STATE.SPAWN
var hitpoints: float = 20.0

onready var normal_weapon: NormalWeapon = $NormalWeapon
onready var laser_beam: RayoLaser = $LaserBeam2D
onready var engine_sound: Motor = $SFX_Engine
onready var hit_sound: AudioStreamPlayer = $SFX_Hit
onready var colisionator: CollisionPolygon2D = $CollisionPolygon2D
onready var estela: Estela = $TrailStartingPoint/Trail2D
onready var estela2: Estela = $TrailStartingPoint2/Trail2D
onready var player_shield: Shield = $Shield
##ARREGLAR ESTO CAPAZ SE PUEDEN PONER EN UN ARRAY

func _ready() -> void:
	 player_state_controler(actual_state)


func input_is_active() -> bool:
	if actual_state in  [PLAYER_STATE.DEAD, PLAYER_STATE.SPAWN]:
		return false
	
	return true


func _on_body_entered(body: Node) -> void:
	if body is Meteor:
		body.destroy_meteor()
		destroy_player()


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "Spawning":
		player_state_controler(PLAYER_STATE.ALIVE)


func _unhandled_input(event: InputEvent) -> void:
	if not input_is_active():
		return
	
	if event.is_action_pressed("disparar_laser_beam"):
		laser_beam.set_is_casting(true)
	
	if event.is_action_released("disparar_laser_beam"):
		laser_beam.set_is_casting(false)
	
	
	if event.is_action_released("mover_adelante") or event.is_action_released("mover_atras"):
		engine_sound.sound_off()
	
	if event.is_action_pressed("mover_adelante"):
		estela.set_max_points(estela_maxima)
		estela2.set_max_points(estela_maxima)
		engine_sound.sound_on()
	
	elif event.is_action_pressed("mover_atras"):
		estela.set_max_points(2)
		estela2.set_max_points(2)
		engine_sound.sound_on()
	
	if event.is_action_pressed("activar_escudo") and not player_shield.get_is_activated():
		player_shield.activate()
	


# warning-ignore:unused_argument
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	apply_central_impulse(empuje.rotated(rotation))
	apply_torque_impulse(direc_rotacion * vel_rotacion)


# warning-ignore:unused_argument
func _process(delta: float) -> void:
	input_jugador()


func input_jugador() -> void:
	if not input_is_active():
		return
	
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


func player_state_controler(new_state: int) -> void:
	match new_state:
		PLAYER_STATE.SPAWN:
			colisionator.set_deferred("disabled", true)
			normal_weapon.set_can_fire(false)
		
		PLAYER_STATE.ALIVE:
			colisionator.set_deferred("disabled", false)
			normal_weapon.set_can_fire(true)
		
		PLAYER_STATE.INVINCIBLE:
			colisionator.set_deferred("disabled", true)
		
		PLAYER_STATE.DEAD:
			colisionator.set_deferred("disabled", true)
			normal_weapon.set_can_fire(false)
			Events.emit_signal("player_destroyed", self, global_position, 2)
			queue_free()
	
	actual_state = new_state


func destroy_player() -> void:
	player_state_controler(PLAYER_STATE.DEAD)


func get_damage(damage: float) -> void:
	hitpoints -= damage
	hit_sound.play()
	
	if hitpoints <= 0.0:
		destroy_player()
