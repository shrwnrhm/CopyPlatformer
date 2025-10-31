extends CharacterBody2D

signal damaged
signal death

@export var speed: float = 400 # How fast the player will move (pixels/sec).
#var velocity: Vector2 = Vector2.ZERO

@export var jump_strength: float = 800.0
@export var special_dash_speed: float = 800
@export var gravity_strength: float = 2000.0
@export var max_health: float = 100.0

@onready var is_jumping = false # unused so far
@onready var is_attacking = false
@onready var is_specialing = false

@onready var facing: int = 1
@onready var facing_locked: bool = false
@onready var health: = max_health

@onready var controller = $AIController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	controller.calculate()

	var horizontal_direction: float = controller.get_horizontal_direction()

	var should_jump: bool = controller.should_jump()
	var should_attack: bool = controller.should_attack()
	var should_special: bool = controller.should_special()
	
	if not facing_locked:
		if horizontal_direction > 0:
			facing = 1
		elif horizontal_direction < 0:
			facing = -1

	# Apply input movement, don't apply if special is being used
	velocity.x = horizontal_direction * speed
	
	if is_specialing:
		velocity.x = facing * special_dash_speed
	
	# Apply jumping and gravity
	if is_on_floor():
		if should_jump:
			velocity.y = -jump_strength
		else:
			velocity.y = 0
	else:
		velocity += get_gravity() * delta
		#velocity.y += gravity_strength * delta

	# Change the position
	move_and_slide()
	
	# Kill player if fallen of the platform # TODO: find a better way to do this
	if position.y > 1000:
		take_damage(max_health)
	
	# Left/Right orientation of the sprite
	if facing > 0:
		$AnimatedSprite2D.flip_h = false
	elif facing < 0:
		$AnimatedSprite2D.flip_h = true
	
	# Start or keep animation
	if not is_attacking and not is_specialing:
		if should_special:
			is_specialing = true
			facing_locked = true
			$AnimationPlayer.play("special")
		elif should_attack:
			is_attacking = true
			$AnimationPlayer.play("attack")
		elif is_on_floor():
			if horizontal_direction != 0:
				$AnimationPlayer.play("run")
			else:
				$AnimationPlayer.play("idle")
		elif velocity.y > 0:
			$AnimationPlayer.play("fall")
		else:
			$AnimationPlayer.play("jump")
	
func take_damage(damage: float):
	health = max(0, health - damage)
	emit_signal("damaged")
	if health == 0:
		emit_signal("death")
		queue_free()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	is_attacking = false
	is_specialing = false
	facing_locked = false
