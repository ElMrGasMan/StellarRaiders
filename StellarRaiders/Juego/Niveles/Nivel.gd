class_name Nivel
extends Node2D


onready var proyectile_storage: Node


func _ready() -> void:
	
	connect_signals()
	create_storages()


func _on_shoot(proyectil:Proyectil) -> void:
	
	proyectile_storage.add_child(proyectil)


func connect_signals():
	
	Events.connect("shoot", self, "_on_shoot")


func create_storages():
	
	proyectile_storage = Node.new()
	proyectile_storage.name = "ProyectileStorage"
	add_child(proyectile_storage)

