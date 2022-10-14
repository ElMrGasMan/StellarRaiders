class_name MeteorRain
extends Node2D


export var cant_meteoritos: int = 8
export var timer_spawn: float = 1.0

var spawners: Array


func _ready() -> void:
	almacenar_spawners()
	conectar_detectores()
	$TimerMeteoritos.wait_time = timer_spawn


func _on_TimerMeteoritos_timeout() -> void:
	if cant_meteoritos == 0:
		$TimerMeteoritos.stop()
		return
	
	spawners[spawner_random()].emit_meteor_signal()
	cant_meteoritos -= 1


func almacenar_spawners() -> void:
	for spawner in $Spawners.get_children():
		spawners.append(spawner)


func spawner_random() -> int:
	randomize()
	return randi() % spawners.size()


func conectar_detectores() -> void:
	for detector in $BordeExteriorDetector.get_children():
		detector.connect("body_entered", self, "_on_detector_body_entered")


func _on_detector_body_entered(body: Node) -> void:
	body.set_esta_dentro_sector(false)


func crear_lluvia(pos: Vector2, num_met: int):
	global_position = pos
	cant_meteoritos = num_met
