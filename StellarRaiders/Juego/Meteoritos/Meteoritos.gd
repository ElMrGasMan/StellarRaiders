class_name Meteor
extends RigidBody2D


export var linear_vel_base: Vector2 = Vector2(200.0, 200.0)
export var angular_vel_base: float = 6.0
export var hitpoints_base: float = 8.0
onready var hit_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D
onready var animations: AnimationPlayer = $AnimationPlayer

export var meteor_speed_range: Vector2 = Vector2(1.2, 1.8)

var hitpoints: float


func _ready() -> void:
	pass


func create_meteor(pos: Vector2, dir: Vector2, size: float) -> void:
	position = pos
	mass *= size
	$Sprite.scale = Vector2.ONE * size
	var radio: int = int($Sprite.texture.get_size().x / 2.4 * size)
	var collision_shape: CircleShape2D = CircleShape2D.new()
	collision_shape.radius = radio
	$CollisionShape2D.shape = collision_shape
	linear_velocity = (linear_vel_base * dir / size) * randomize_speed()
	angular_velocity = (angular_vel_base / size) * randomize_speed()
	hitpoints = hitpoints_base * size


func get_damage(damage: float) -> void:
	hitpoints -= damage
	animations.play("Meteor_Hit")
	
	if hitpoints <= 0.0:
		destroy_meteor()


func destroy_meteor() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	Events.emit_signal("destroy_meteor", global_position)
	queue_free()


func randomize_speed() -> float:
	randomize()
	return rand_range(meteor_speed_range[0], meteor_speed_range[1])
