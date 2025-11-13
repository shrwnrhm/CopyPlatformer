extends AbstractCharacter

@export var special_dash_speed_multipler: float = 2

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	max_health = 100
	speed = 400
	jump_strength = 800
	special_cooldown = 1


func apply_movement(delta: float, speed_multiplier: Vector2 = Vector2.ONE) -> void:
	if specialing:
		horizontal_direction = facing
		super.apply_movement(delta, Vector2(special_dash_speed_multipler, 1))
	else:
		super.apply_movement(delta)
