class_name Nivel
extends Node2D


export var explosion: PackedScene = null

onready var proyectile_storage: Node


func _ready() -> void:
	connect_signals()
	create_storages()


func _on_shoot(proyectil:Proyectil) -> void:
	proyectile_storage.add_child(proyectil)


func _on_player_destroyed(position: Vector2, num_explosions: int) -> void:
	for i in range(num_explosions):
		var new_explosion:Node2D = explosion.instance()
		new_explosion.global_position = position
		add_child(new_explosion)
		yield(get_tree().create_timer(0.4), "timeout")


func connect_signals() -> void:
	Events.connect("shoot", self, "_on_shoot")
	Events.connect("player_destroyed", self, "_on_player_destroyed")


func create_storages() -> void:
	proyectile_storage = Node.new()
	proyectile_storage.name = "ProyectileStorage"
	add_child(proyectile_storage)

