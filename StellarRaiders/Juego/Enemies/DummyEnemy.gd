class_name Enemies
extends Node2D


onready var weapon: Node2D = $NormalWeapon

var hitpoints: float = 10.0


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	weapon.set_is_firing(true)


func _on_body_entered(body: Node) -> void:
	if body is Jugador:
		body.destroy_player()


func get_damage(damage: float):
	hitpoints -= damage
	
	if hitpoints <= 0.0:
		queue_free()
