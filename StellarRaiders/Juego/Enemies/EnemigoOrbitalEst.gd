class_name EnemigoOrbital
extends EnemigoBase


export var rango_ataque_maximo: float = 1000.0
export var vel_movimiento: float = 250.0

var estacion_custodiada: Node2D
var ruta_ia: Path2D
var path_follow: PathFollow2D

onready var detector_estacion: RayCast2D = $RayCastObstaculo


func _ready() -> void:
# warning-ignore:return_value_discarded
	Events.connect("base_destruida", self, "_on_base_destruida")
	normal_weapon.set_is_firing(true)


func _process(delta: float) -> void:
	path_follow.offset += vel_movimiento * delta
	position = path_follow.global_position


func mirar_al_jugador() -> void:
	.mirar_al_jugador()
	
	if dir_jugador.length() > rango_ataque_maximo or detector_estacion.is_colliding():
		normal_weapon.set_is_firing(false)
	
	else:
		normal_weapon.set_is_firing(true)


func crear_nave(posicion: Vector2, custodiada: Node2D, ruta_custodiada: Path2D) -> void:
	global_position = posicion
	estacion_custodiada = custodiada
	ruta_ia = ruta_custodiada
	path_follow = PathFollow2D.new()
	ruta_ia.add_child(path_follow)


func _on_base_destruida(_p, base: Node2D) -> void:
	if base == estacion_custodiada:
		destroy_player()
