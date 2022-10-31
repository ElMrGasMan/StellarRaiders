class_name Escudo
extends Area2D


onready var animations: AnimationPlayer = $AnimationPlayer
onready var collisionator: CollisionShape2D = $CollisionShape2D
onready var timer_regeneracion: Timer = $TimerRegeneracion

export var energy_hitpoints: float = 10.0
export var ratio_regeneracion: float = 0.05
export var es_enemigo: bool = false

var is_activated: bool = false setget, get_is_activated
var regeneracion_activada: bool = false
var energia_maxima: float


func _ready() -> void:
	energia_maxima = energy_hitpoints
	set_process(false)
	status_collisionator(true)


# warning-ignore:unused_argument
func _process(delta: float) -> void:
	if regeneracion_activada: 
		energia_control(ratio_regeneracion)


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "Activating" and is_activated:
		animations.play("Activated")
		status_collisionator(false)


func _on_body_entered(body: Node) -> void:
	body.queue_free()


func _on_TimerRegeneracion_timeout() -> void:
	set_process(true)
	regeneracion_activada = true


func get_is_activated() -> bool:
	return is_activated


func energia_control(valor: float) -> void:
	energy_hitpoints += valor
	
	Events.emit_signal("actualizar_energia_escudo", energia_maxima, energy_hitpoints)
	
	if energy_hitpoints > energia_maxima:
		energy_hitpoints = energia_maxima
		regeneracion_activada = false
		set_process(false)
	
	elif energy_hitpoints <= 0.0:
		Events.emit_signal("ocultar_energia_escudo")
		deactivate()


func deactivate() -> void:
	set_process(false)
	is_activated = false
	status_collisionator(true)
	animations.play_backwards("Activating")
	timer_regeneracion.set_paused(true)


func activate() -> void:
	if energy_hitpoints > 0.0:
		animations.play("Activating")
		set_process(true)
		status_collisionator(true)
		is_activated = true
		timer_regeneracion.set_paused(false)


func status_collisionator(status: bool) -> void:
	collisionator.set_deferred("disabled", status)


func get_damage(damage: float) -> void:
	energia_control(-damage)
	
	if not es_enemigo:
		timer_regeneracion.start()
