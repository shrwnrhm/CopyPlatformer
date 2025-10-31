extends AbstractCharacter

@export var special_dash_speed: float = 800
@export var special_dash_cooldown: float = 2 # in seconds

@onready var special_dash_cooldown_tracker: float = special_dash_cooldown # in seconds

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	max_health = 100
	speed = 400
	jump_strength = 800


func apply_post_movement(delta: float) -> void:
	if specialing:
		velocity.x = facing * special_dash_speed

func apply_pre_state_change(delta: float) -> void:
	if should_special and special_dash_cooldown_tracker < special_dash_cooldown:
		should_special = false
		special_dash_cooldown_tracker += delta
	elif should_special:
		special_dash_cooldown_tracker = 0
