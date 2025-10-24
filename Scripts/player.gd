extends CharacterBody2D


@export var speed: float = 400 # How fast the player will move (pixels/sec).
#var velocity: Vector2 = Vector2.ZERO

@export var jump_strength: float = 800.0
@export var gravity_strength: float = 2000.0

@onready var is_jumping = false # unused so far
@onready var is_attacking = false
@onready var is_specialing = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	# Get controller input
	var input_dir = Input.get_axis("move_left","move_right")
	var input_jump = Input.is_action_pressed("jump")
	var input_attack = Input.is_action_pressed("attack")
	var input_special = Input.is_action_pressed("special")
	
	# Apply input movement
	velocity.x = input_dir * speed
	
	# Apply jumping and gravity
	if is_on_floor():
		if input_jump:
			velocity.y = -jump_strength
		else:
			velocity.y = 0
	else:
		velocity.y += gravity_strength * delta

	# Change the position
	move_and_slide()
	
	# Left/Right orientation of the sprite
	if input_dir > 0:
		$AnimatedSprite2D.flip_h = false
	elif input_dir < 0:
		$AnimatedSprite2D.flip_h = true
	
	# Start or keep animation
	if not is_attacking and not is_specialing:
		if input_special:
			is_specialing = true
			$AnimatedSprite2D.play("special")
		elif input_attack:
			is_attacking = true
			$AnimatedSprite2D.play("attack")
		elif is_on_floor():
			if input_dir != 0:
				$AnimatedSprite2D.play("run")
			else:
				$AnimatedSprite2D.play("idle")
		elif velocity.y > 0:
			$AnimatedSprite2D.play("falling")
		else:
			$AnimatedSprite2D.play("jump")
	
func _on_animated_sprite_2d_animation_finished() -> void:
	is_attacking = false
	is_specialing = false
	print("Animation finished!")
