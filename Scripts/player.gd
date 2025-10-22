extends CharacterBody2D


@export var speed: float = 400 # How fast the player will move (pixels/sec).
#var velocity: Vector2 = Vector2.ZERO

@export var jump_strength: float = 800.0
@export var gravity_strength: float = 2000.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input_dir = Input.get_axis("move_left","move_right")
	
	# Left/Right orientation of the sprite
	if input_dir > 0:
		$AnimatedSprite2D.flip_h = false
	elif input_dir < 0:
		$AnimatedSprite2D.flip_h = true
	
	# Use animation depending on the input
	if not is_on_floor():
		if velocity.y < 0:
			$AnimatedSprite2D.play("falling")	
	elif input_dir != 0:
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")
	

func _physics_process(delta: float) -> void:
	# Get controller input
	var input_dir = Input.get_axis("move_left","move_right")
	var input_jump = Input.is_action_pressed("jump")
	
	# Apply input movement
	velocity.x = input_dir * speed
	
	# Apply gravity
	
	if is_on_floor():
		if input_jump:
			velocity.y = -jump_strength
		else:
			velocity.y = 0
	else:
		velocity.y += gravity_strength * delta
		
	# Change the position
	#move_and_collide(velocity * delta)	
	move_and_slide()
	
	# TODO: make camera follow the player position
