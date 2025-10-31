class_name player_controller
extends Node2D

@onready var direction: Vector2 = Vector2.ZERO
@onready var horizontal_direction: float = 0
@onready var vertical_direction: float = 0
@onready var input_jump: bool = false
@onready var input_attack: bool = false
@onready var input_special: bool = false

# returns the direction towards the player
func calculate() -> void:
	horizontal_direction = Input.get_axis("move_left","move_right")
	vertical_direction = Input.get_axis("move_up","move_down")
	
	input_jump = Input.is_action_pressed("jump")
	input_attack = Input.is_action_pressed("attack")
	input_special = Input.is_action_pressed("special")

	direction = Vector2(horizontal_direction, vertical_direction).normalized()
	
func get_direction() -> Vector2:
	return direction
	
func get_horizontal_direction() -> float:
	return horizontal_direction

func get_vertical_direction() -> float:
	return vertical_direction
	
func should_jump() -> bool:
	return input_jump

func should_attack() -> bool:
	return input_attack
	
func should_special() -> bool:
	return input_special
