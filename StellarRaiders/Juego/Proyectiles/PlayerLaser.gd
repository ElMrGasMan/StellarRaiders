class_name Proyectil

extends Area2D


var velocidad: Vector2 = Vector2.ZERO
var damage: float


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	position += velocidad * delta
	pass


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func crear_proyectil(pos: Vector2, rotacion: float, vel: float, dam_proy: float) -> void:
	position = pos
	rotation = rotacion
	velocidad = Vector2(vel, 0).rotated(rotacion)
	damage = dam_proy
