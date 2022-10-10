class_name Shield
extends Area2D


onready var animations: AnimationPlayer = $AnimationPlayer
onready var collisionator: CollisionShape2D = $CollisionShape2D

export var total_energy: float = 10.0
export var ratio_consumption: float = 1.25

var is_activated: bool = false setget, get_is_activated


func _ready() -> void:
	set_process(false)
	status_collisionator(true)


func _process(delta: float) -> void:
	total_energy -= ratio_consumption * delta
	print(total_energy)
	
	if total_energy <= 0.0:
		deactivate()


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "Activating" and is_activated:
		animations.play("Activated")
		set_process(true)
		status_collisionator(false)


func _on_body_entered(body: Node) -> void:
	body.queue_free()


func deactivate() -> void:
	set_process(false)
	is_activated = false
	status_collisionator(true)
	animations.play_backwards("Activating")


func activate() -> void:
	if total_energy > 0.0:
		animations.play("Activating")
		status_collisionator(true)
		is_activated = true


func status_collisionator(status: bool) -> void:
	collisionator.set_deferred("disabled", status)


func get_is_activated() -> bool:
	return is_activated
