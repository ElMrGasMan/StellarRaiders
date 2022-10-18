class_name EstacionEnemiga
extends Node2D


export var hitpoints: float = 55.0

onready var animaciones: AnimationPlayer = $AnimationPlayer
onready var sfx_hit: AudioStreamPlayer2D = $AudioStreamPlayer2D
onready var sprites: Node2D = $NodoSprites

var esta_destruido: bool = false
var array_sprites: Array


func _ready() -> void:
	animaciones.play(elegir_animacion_aleatoria())


func elegir_animacion_aleatoria() -> String:
	randomize()
	var num_anim: int = animaciones.get_animation_list().size() - 1
	var indice_anim: int = randi() % num_anim + 1
	var lista_animaciones: Array = animaciones.get_animation_list()
	
	return lista_animaciones[indice_anim]


func get_damage(damage: float):
	hitpoints -= damage
	
	if hitpoints <= 0.0 and not esta_destruido:
		
		for i in sprites.get_children(): 
			array_sprites.append(i.global_position)
		
		esta_destruido = true
		animaciones.play("Destruccion")
		Events.emit_signal("base_destruida", array_sprites)
		
	
	sfx_hit.play()


func _on_AreaColision_body_entered(body: Node) -> void:
	if body.has_method("destroy_player"):
		body.destroy_player()


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "Destruccion":
		queue_free()
