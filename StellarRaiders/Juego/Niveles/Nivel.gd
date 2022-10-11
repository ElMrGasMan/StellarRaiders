class_name Nivel
extends Node2D


export var explosion: PackedScene = null
export var meteor: PackedScene = null
export var explosion_meteor: PackedScene = null

onready var proyectile_storage: Node
onready var meteor_storage: Node

func _ready() -> void:
	connect_signals()
	create_storages()


func _on_shoot(proyectil:Proyectil) -> void:
	proyectile_storage.add_child(proyectil)


func _on_player_destroyed(position: Vector2, num_explosions: int) -> void:
# warning-ignore:unused_variable
	for i in range(num_explosions):
		var new_explosion:Node2D = explosion.instance()
		new_explosion.global_position = position
		add_child(new_explosion)
		yield(get_tree().create_timer(0.4), "timeout")


func _on_destroy_meteor(position_explosion: Vector2) -> void:
	var new_explosion:Node2D = explosion_meteor.instance()
	new_explosion.global_position = position_explosion
	add_child(new_explosion)


func _on_shoot_meteor(position_spawn: Vector2, direction : Vector2, size: float) -> void:
	var new_meteor: Meteor = meteor.instance()
	new_meteor.create_meteor(position_spawn, direction, size)
	meteor_storage.add_child(new_meteor)


func connect_signals() -> void:
# warning-ignore:return_value_discarded
	Events.connect("shoot", self, "_on_shoot")
# warning-ignore:return_value_discarded
	Events.connect("player_destroyed", self, "_on_player_destroyed")
# warning-ignore:return_value_discarded
	Events.connect("shoot_meteor", self, "_on_shoot_meteor")
	Events.connect("destroy_meteor", self, "_on_destroy_meteor")

func create_storages() -> void:
	proyectile_storage = Node.new()
	proyectile_storage.name = "ProyectileStorage"
	add_child(proyectile_storage)
	
	meteor_storage = Node.new()
	meteor_storage.name = "MeteorStorage"
	add_child(meteor_storage)

