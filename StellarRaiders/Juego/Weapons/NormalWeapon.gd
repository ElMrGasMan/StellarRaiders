class_name NormalWeapon
extends Node2D


export var proyectile:PackedScene = null
export var fire_rate: float = 0.6
export var proyectile_velocity: int = 110
export var proyectile_damage: int = 2

onready var timer_rateoffire: Timer = $RateOfFire
onready var shooting_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D
onready var cooldown_down: bool = true
onready var is_firing: bool = false setget set_is_firing
onready var can_fire: bool = false setget set_can_fire

var shooting_points: Array = []


func set_is_firing(shooting: bool) -> void:
	is_firing = shooting


func set_can_fire(weapon_ready: bool) -> void:
	can_fire = weapon_ready


func _ready() -> void:
	storage_shooting_points()
	timer_rateoffire.wait_time = fire_rate


func _process(_delta: float) -> void:
	if is_firing and cooldown_down:
		shoot()


func _on_RateOfFire_timeout() -> void:
	cooldown_down = true


func storage_shooting_points() -> void:
	for node in get_children():
		
		if node is Position2D:
			shooting_points.append(node)


func shoot() -> void:
	cooldown_down = false
	shooting_sound.play()
	timer_rateoffire.start()
	shooting_sound.play()
	
	for muzzle_point in shooting_points:
		
		var new_proyectile: Proyectil = proyectile.instance()
		
		new_proyectile.crear_proyectil(
			muzzle_point.global_position,
			get_owner().rotation,
			proyectile_velocity,
			proyectile_damage
			)
		Events.emit_signal("shoot", new_proyectile)
