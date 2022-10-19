class_name Proyectil

extends Area2D


var velocidad: Vector2 = Vector2.ZERO
var damages: float


func _physics_process(delta: float) -> void:
	position += velocidad * delta


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	damage(area)


func _on_body_entered(body: Node) -> void:
	damage(body)


func damage(other_body: CollisionObject2D) -> void:
	if other_body.has_method("get_damage"):
		other_body.get_damage(damages)
	
	queue_free()


func crear_proyectil(pos: Vector2, rotacion: float, vel: float, dam_proy: float) -> void:
	position = pos
	rotation = rotacion
	velocidad = Vector2(vel, 0).rotated(rotacion)
	damages = dam_proy

