class_name EnemigoBase
extends NaveBase


func _ready() -> void:
	normal_weapon.set_is_firing(true)


func _on_body_entered(body: Node) -> void:
	._on_body_entered(body)
	
	if body is Jugador:
		body.destroy_player()
		destroy_player()
