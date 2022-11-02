class_name LanzaMisiles
extends Node2D


onready var hit_sound: AudioStreamPlayer2D = $Sfx_hit
onready var colisionador: CollisionShape2D = $AreaColision/CollisionShape2D
onready var animaciones: AnimationPlayer = $AnimationPlayer
onready var ray_cast_detector: RayCast2D = $RayCastDetectarJugador
onready var timer_cooldown_misiles: Timer = $TimerCooldown

export var misiles: PackedScene = null
export var hitpoints: float = 25.0
export var cant_explosiones: int = 3

var dir_jugador: Vector2 
var jugador_objetivo: Jugador = null
var frame_control: int = 0
var rotacion_jugador: float
var posicion_lanzador: Vector2
var detectado: bool = false


func _ready() -> void:
	jugador_objetivo = DataJuego.get_jugador_actual()
# warning-ignore:return_value_discarded
	Events.connect("player_destroyed", self, "_on_jugador_destruido")
	posicion_lanzador = global_position


# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	frame_control += 1
	
	if frame_control % 3 == 0:
		mirar_al_jugador()
		
		if ray_cast_detector.is_colliding() and not detectado:
			timer_cooldown_misiles.start()
			spawn_misil()
			detectado = true


func _on_TimerCooldown_timeout() -> void:
	animaciones.play("LanzarMisil")
	spawn_misil()


func _on_AreaColision_body_entered(body: Node) -> void:
	body.destroy_player()
	destroy()


func _on_jugador_destruido(nave: NaveBase, _posicion, _explosiones) -> void:
	if nave is Jugador:
		jugador_objetivo = null
	
	#if nave.is_in_group("minimapa"):
		#Events.emit_signal("objeto_minimapa_destruido", nave)


func mirar_al_jugador() -> void:
	if jugador_objetivo:
		dir_jugador = jugador_objetivo.global_position - global_position
		rotation = dir_jugador.angle()
		rotacion_jugador = rotation


func get_damage(damage: float) -> void:
	hitpoints -= damage
	hit_sound.play()
	
	if hitpoints <= 0.0:
		destroy()


func destroy() -> void:
	colisionador.set_deferred("disabled", true)
	Events.emit_signal("lanza_misiles_destruido", self, cant_explosiones, posicion_lanzador)
	Events.emit_signal("objeto_minimapa_destruido", self)
	queue_free()


func spawn_misil() -> void:
	var new_misil: Misil = misiles.instance()
	new_misil.crear_misil(global_position, rotacion_jugador, self)
	Events.emit_signal("misil_lanzado", new_misil)
