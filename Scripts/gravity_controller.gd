extends Node2D


signal update_velocity(new_velocity)

@export var gravity_strength: float = 800.0
var velocity: Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	velocity.y += gravity_strength * delta
	emit_signal("update_velocity", velocity)
