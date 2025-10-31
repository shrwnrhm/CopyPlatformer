class_name ai_controller
extends Node2D

@onready var target_position: Vector2 = Vector2.ZERO
@onready var direction: Vector2 = Vector2.ZERO
@onready var distance_vector: Vector2 = Vector2.ZERO
@onready var distance: float = 0

# returns the direction towards the player
# TODO: provide a target position as a parameter, and call this function with a timer instead (for slower update timese)
func calculate() -> void:
	# Set player as the target position
	# TODO: a lot, no need to call every time, don't cycle over the list but get random, line of sightm
	var players = get_tree().get_nodes_in_group("Player")
	if len(players) == 0:
		return
		
	target_position = players[0].get_player_position()
		
	# Calculate the direction from the current position to the target position
	#var direction: Vector2 = (position - target_position).normalized()
	distance_vector = target_position - global_position
	distance = distance_vector.length()
	
	direction = distance_vector.normalized()

func get_direction() -> Vector2:
	return direction
	
func get_horizontal_direction() -> float:		
	if direction.x > 0:
		return 1
	elif direction.x < 0:
		return -1
	return 0
	
func should_jump() -> bool:
	return direction.y < -0.5

func should_attack() -> bool:
	return distance < 100
	
func should_special() -> bool:
	return -0.1 < direction.y and direction.y < 0.1
