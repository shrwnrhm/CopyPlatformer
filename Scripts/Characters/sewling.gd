extends AbstractCharacter

@export var special_dash_speed: float = 800

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	max_health = 100
	speed = 400
	jump_strength = 800


func apply_movement(delta: float) -> void:
	super.apply_movement(delta)
	if specialing:
		velocity.x = facing * special_dash_speed
