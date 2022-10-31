class_name Meteoro
extends RigidBody2D


export var linear_vel_base: Vector2 = Vector2(200.0, 200.0)
export var angular_vel_base: float = 6.0
export var hitpoints_base: float = 8.0
export var meteor_speed_range: Vector2 = Vector2(1.2, 1.8)

onready var hit_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D
onready var animations: AnimationPlayer = $AnimationPlayer

var hitpoints: float
var esta_dentro_sector: bool = true setget set_esta_dentro_sector
var pos_spawn_original : Vector2
var vel_spawn_original : Vector2
var esta_destruido: bool = false


func _ready() -> void:
	pass


func set_esta_dentro_sector(value: bool) -> void:
	esta_dentro_sector = value


func create_meteor(pos: Vector2, dir: Vector2, size: float) -> void:
	position = pos
	pos_spawn_original = position
	mass *= size
	$Sprite.scale = Vector2.ONE * size
	var radio: int = int($Sprite.texture.get_size().x / 2.4 * size)
	var collision_shape: CircleShape2D = CircleShape2D.new()
	collision_shape.radius = radio
	$CollisionShape2D.shape = collision_shape
	linear_velocity = (linear_vel_base * dir / size) * randomize_speed()
	vel_spawn_original = linear_velocity
	angular_velocity = (angular_vel_base / size) * randomize_speed()
	hitpoints = hitpoints_base * size


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if esta_dentro_sector:
		return
	
	var mi_transform := state.get_transform()
	mi_transform.origin = pos_spawn_original
	linear_velocity = vel_spawn_original
	state.set_transform(mi_transform)
	esta_dentro_sector = true


func get_damage(damage: float) -> void:
	hitpoints -= damage
	animations.play("Meteor_Hit")
	
	if hitpoints <= 0.0 and not esta_destruido:
		esta_destruido = true
		destroy_meteor()


func destroy_meteor() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	Events.emit_signal("destroy_meteor", global_position)
	queue_free()


func randomize_speed() -> float:
	randomize()
	return rand_range(meteor_speed_range[0], meteor_speed_range[1])
