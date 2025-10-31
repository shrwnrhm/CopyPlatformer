class_name Hitbox
extends Area2D

@export var damage: float = 10

func _init() -> void:
	collision_layer = 0x100 # should be a 4 for collision layer 3
	collision_mask = 0x1000 # should be a 8 for collision layer 4
