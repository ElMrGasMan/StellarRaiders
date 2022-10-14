extends Area2D


export(String, "vacio", "Meteorite", "Enemy") var clase_peligro
export var num_peligros: int = 8


func _on_body_entered(_body: Node) -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	yield(get_tree().create_timer(0.1), "timeout")
	mandar_senial()


func mandar_senial() -> void:
	Events.emit_signal("jugador_en_sector_peligroso", $PosicionCentroCamara.global_position, clase_peligro, num_peligros)
	queue_free()
