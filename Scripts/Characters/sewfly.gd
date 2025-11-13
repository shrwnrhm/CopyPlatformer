extends AbstractCharacter


func _init() -> void:
	sprite_facing_right = false
	max_health = 20
	speed = 200
	attack_cooldown = 0.2
	flying = true

# TODO: this is only temporary, overhaul all of this attack damage increase logic
@onready var reset_damage_value: float = $Hitbox.damage
func enable_attack_state_attack_damage() -> void:
	$Hitbox.damage = 10

func reset_to_default_state_stats() -> void:
		$Hitbox.damage = reset_damage_value
