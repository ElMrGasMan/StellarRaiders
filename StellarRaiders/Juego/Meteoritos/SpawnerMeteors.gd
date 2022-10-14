class_name Meteor_Spawner
extends Position2D


export var meteor_direction: Vector2 = Vector2(1, 1)
export var meteor_size_range: Vector2 = Vector2(0.7, 2.6)


func emit_meteor_signal() -> void:
	Events.emit_signal("shoot_meteor", global_position, meteor_direction, size_meteor_randomizer())


func size_meteor_randomizer() -> float:
	randomize()
	return rand_range(meteor_size_range[0], meteor_size_range[1])
