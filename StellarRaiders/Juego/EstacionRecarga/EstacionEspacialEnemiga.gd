class_name EstacionEnemiga
extends Node2D


export var hitpoints: float = 55.0
export var guardias_orbitales: PackedScene = null
export var cant_guardianes: int = 5
export var intervalo_spawn_guardianes: float = 1.0
export(Array, PackedScene) var rutas_guardias

var esta_destruido: bool = false
var posicion_spawn: Vector2 = Vector2.ZERO
var array_sprites: Array
var ruta_random_seleccionada: Path2D

onready var animaciones: AnimationPlayer = $AnimationPlayer
onready var sfx_hit: AudioStreamPlayer2D = $AudioStreamPlayer2D
onready var sprites: Node2D = $NodoSprites
onready var spawners_timer: Timer = $TimerSpawnGuardianes
onready var barra_hitpoints: ProgressBar = $BarraHitPoints


func _ready() -> void:
	barra_hitpoints.settear_valores(hitpoints)
	spawners_timer.wait_time = intervalo_spawn_guardianes
	animaciones.play(elegir_animacion_aleatoria())
	seleccionar_ruta_aleatoria()


func _on_AreaColision_body_entered(body: Node) -> void:
	if body.has_method("destroy_player"):
		body.destroy_player()


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "4Destruccion":
		queue_free()
	
	elif anim_name == "3Giro360" or anim_name == "2Giro-360" or anim_name == "1Default":
		animaciones.play(elegir_animacion_aleatoria())


func _on_VisibilityNotifier2D_screen_entered() -> void:
	$VisibilityNotifier2D.queue_free()
	posicion_spawn = cuadrantes_spawn()
	spawn_guardias()
	spawners_timer.start()


func _on_TimerSpawnGuardianes_timeout() -> void:
	if cant_guardianes == 0:
		spawners_timer.stop()
		return
	spawn_guardias()


func seleccionar_ruta_aleatoria() -> void:
	randomize()
	var indice_ruta: int = randi() % rutas_guardias.size() - 1
	ruta_random_seleccionada = rutas_guardias[indice_ruta].instance()
	add_child(ruta_random_seleccionada)


func elegir_animacion_aleatoria() -> String:
	randomize()
	var num_anim: int = animaciones.get_animation_list().size() - 1
	var indice_anim: int = randi() % num_anim
	var lista_animaciones: Array = animaciones.get_animation_list()
	
	return lista_animaciones[indice_anim]


func get_damage(damage: float):
	hitpoints -= damage
	
	if hitpoints <= 0.0 and not esta_destruido:
		
		for i in sprites.get_children(): 
			array_sprites.append(i.global_position)
		
		esta_destruido = true
		animaciones.play("4Destruccion")
		Events.emit_signal("base_destruida", array_sprites, self)
		Events.emit_signal("objeto_minimapa_destruido", self)
		queue_free()
		
	
	barra_hitpoints.controlar_hitpoints_barra_notween(hitpoints)
	sfx_hit.play()


func spawn_guardias() -> void:
	cant_guardianes -= 1
	ruta_random_seleccionada.global_position = global_position
	
	var new_guardia: EnemigoOrbital = guardias_orbitales.instance()
	new_guardia.crear_nave(global_position + posicion_spawn, self, ruta_random_seleccionada)
	Events.emit_signal("spawn_enemigo_orbital", new_guardia)


func cuadrantes_spawn() -> Vector2:
	var jugador: Jugador = DataJuego.get_jugador_actual()
	
	if not jugador:
		return Vector2.ZERO
	
	var direccion_jugador: Vector2 = jugador.global_position - global_position
	var angulo_jugador: float = rad2deg(direccion_jugador.angle())
	
	if abs(angulo_jugador) <= 45.0:
		#El jugador viene por la derecha
		ruta_random_seleccionada.rotation_degrees = 180.0
		return $PosicionesSpawnOrbitales/PosicionEste.position
	
	elif abs(angulo_jugador) > 135.0 and abs(angulo_jugador) <= 180.0:
		#El jugador viene por la izquierda
		ruta_random_seleccionada.rotation_degrees = 0.0
		return $PosicionesSpawnOrbitales/PosicionOeste.position
	
	elif abs(angulo_jugador) > 45.0 and abs(angulo_jugador) <= 135.0:
		#El jugador viene por el Norte o el Sur
		if sign(angulo_jugador):
			#El jugador viene por el Sur
			ruta_random_seleccionada.rotation_degrees = 270.0
			return $PosicionesSpawnOrbitales/PosicionSur.position
		
		else:
			#El jugador viene por el Norte
			ruta_random_seleccionada.rotation_degrees = 90.0
			return $PosicionesSpawnOrbitales/PosicionNorte.position
	
	#Si todo lo demas falla que spawneen en el Este nomas
	return $PosicionesSpawnOrbitales/PosicionEste.position
