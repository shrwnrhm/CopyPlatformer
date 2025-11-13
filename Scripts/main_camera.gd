extends Camera2D

# Path to the player node in the scene
@export var target: Player # adjust to your scene tree

# Smoothing factor. Larger values result in faster following.
@export var follow_speed: float = 800.0

# Deadzone Area Size
@export var deadzone_area: Vector2 = Vector2(200, 150)

# the deadzone vectors with the screen center as origin
@onready var min_deadzone_vector: Vector2 = -deadzone_area / 2
@onready var max_deadzone_vector: Vector2 = deadzone_area / 2

# Internal reference to the player
#@onready var target: Node2D = get_node(target_path) as Node2D

func _process(delta: float) -> void:
	if not is_instance_valid(target):
		print("target is not a valid target!")
		return

	var target_global_position: Vector2 = target.get_player_position()
	
	# calculate the distance between camera position and the target
	var relative_target_position: Vector2 = target_global_position - global_position
	
	# contrain the distance within the deadzone area
	var relative_desired_position: Vector2 = relative_target_position.clamp(min_deadzone_vector, max_deadzone_vector)
	
	# apply the contrained distance and possible offset for the desired camera position
	var desired_position: Vector2 = target_global_position - relative_desired_position + offset
	
	# Move the camera gradually towards the desired position
	position = position.move_toward(desired_position, follow_speed * delta)
