extends CharacterBody2D

@export var speed: float = 200.0

@onready var target_position: Vector2 = Vector2.ZERO
@onready var facing: int = 1

func _physics_process(delta: float) -> void:
	# Set player as the target position
	# TODO: a lot, no need to call every time, don't cycle over the list but get random, line of sightm
	for player in get_tree().get_nodes_in_group("Player"):
		target_position = player.global_position
	
	# Move towards the target position
	#var direction: Vector2 = (position - target_position).normalized()
	var direction: Vector2 = (target_position - global_position).normalized()
	print(direction)
	#velocity = direction * move_toward(velocity.length(), SPEED, delta) * delta
	velocity = direction * speed
	
	# Add the gravity.
	if not is_on_floor():
		# this creature can fly, so no gravity is applied
		#velocity += get_gravity() * delta
		pass
	
	if direction.x > 0:
		facing = 1
	elif direction.x < 0:
		facing = -1
		
	# Left/Right orientation of the sprite
	if facing > 0:
		$AnimatedSprite2D.flip_h = true
	elif facing < 0:
		$AnimatedSprite2D.flip_h = false
	
	$AnimatedSprite2D.play("idle")

	move_and_slide()
