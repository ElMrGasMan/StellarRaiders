class_name NaveBase
extends RigidBody2D


enum PLAYER_STATE {SPAWN, ALIVE, INVINCIBLE, DEAD}

export var hitpoints: float = 20.0
export var cant_explosiones: int = 2


var actual_state: int = PLAYER_STATE.SPAWN


onready var normal_weapon: NormalWeapon = $NormalWeapon
onready var hit_sound: AudioStreamPlayer = $SFX_Hit
onready var colisionator: CollisionPolygon2D = $CollisionPolygon2D


func _ready() -> void:
	 player_state_controler(actual_state)


func _on_body_entered(body: Node) -> void:
	if body is Meteor:
		body.destroy_meteor()
		destroy_player()


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "Spawning":
		player_state_controler(PLAYER_STATE.ALIVE)


func player_state_controler(new_state: int) -> void:
	match new_state:
		PLAYER_STATE.SPAWN:
			colisionator.set_deferred("disabled", true)
			normal_weapon.set_can_fire(false)
		
		PLAYER_STATE.ALIVE:
			colisionator.set_deferred("disabled", false)
			normal_weapon.set_can_fire(true)
		
		PLAYER_STATE.INVINCIBLE:
			colisionator.set_deferred("disabled", true)
		
		PLAYER_STATE.DEAD:
			colisionator.set_deferred("disabled", true)
			normal_weapon.set_can_fire(false)
			Events.emit_signal("player_destroyed", self, global_position, cant_explosiones)
			queue_free()
	
	actual_state = new_state


func destroy_player() -> void:
	player_state_controler(PLAYER_STATE.DEAD)


func get_damage(damage: float) -> void:
	hitpoints -= damage
	hit_sound.play()
	
	if hitpoints <= 0.0:
		destroy_player()
