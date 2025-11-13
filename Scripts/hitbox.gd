class_name Hitbox
extends Area2D

@export var damage: float = 10
@export var knockback_strength: float = 1000
#@export var knockback_direction: Vector2 = Vector2.ZERO

func _init() -> void:
	collision_layer = 0x100 # should be a 4 for collision layer 3
	collision_mask = 0x1000 # should be a 8 for collision layer 4
	#knockback_direction = knockback_direction.normalized()
