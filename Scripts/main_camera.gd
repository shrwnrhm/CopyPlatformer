extends Camera2D

# Path to the player node in the scene
@export var target: Node2D # adjust to your scene tree

# Smoothing factor. Larger values resu  lt in faster following.
@export var follow_speed: float = 750.0

#Optional offset to keep the camera a bit above or behind the player
#@export var offset: Vector2 = Vector2(0, 0)

# Internal reference to the player
#@onready var target: Node2D = get_node(target_path) as Node2D

func _process(delta: float) -> void:
	if not is_instance_valid(target):
		print("target is not a valid target!")
		return

	# Desired position is the player's position plus an offset
	var desired_position: Vector2 = target.global_position + offset

	# Move the camera gradually towards the targets position
	position = position.move_toward(desired_position, follow_speed * delta)
