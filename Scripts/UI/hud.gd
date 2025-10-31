extends Control

@export var player: Player

func _ready() -> void:
	player.connect("damaged", update_health)
	update_health()

func update_health():
	var health_percentage = player.get_health() / player.get_max_health()
	$HealthBar.set_value_no_signal(health_percentage)
