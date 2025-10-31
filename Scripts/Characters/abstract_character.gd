@abstract class_name AbstractCharacter
extends CharacterBody2D

signal damaged
signal death

# Sprite Information
@export var sprite_facing_right: bool = true

# Base Stats
@export var max_health: float = 100.0
@export var speed: float = 400.0
@export var jump_strength: float = 800.0

# Abilities
@export var flying: bool = false

# Changing Stats
@onready var health: = max_health

# State Trackers
@onready var jumping = false
@onready var attacking = false
@onready var specialing = false
@onready var facing: int = 1 if sprite_facing_right else -1 # -1: Left, 1: Right
@onready var facing_locked: bool = false

@onready var controller = $AIController
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# controller variables
@onready var should_special: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_player_animation_finished)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Get the directives of the controller component
	controller.calculate()
	#var direction: Vector2 = controller.get_direction()
	var horizontal_direction: float = controller.get_horizontal_direction()
	#var should_jump: bool = controller.should_jump()
	#var should_attack: bool = controller.should_attack()
	should_special = controller.should_special()
	
	apply_movement(delta)
	apply_post_movement(delta)

	# Apply sprite facing direction
	if not facing_locked:
		if horizontal_direction > 0:
			facing = 1 if sprite_facing_right else -1
		elif horizontal_direction < 0:
			facing = -1 if sprite_facing_right else 1
	
	# Move the character based on the velocity
	move_and_slide()

	# Kill the character if it falls too far down # TODO: find a better way to do this
	if position.y > 1000:
		take_damage(delta * max_health / 10)
		
	# Apply Left/Right orientation of the sprite
	if facing > 0:
		$AnimatedSprite2D.flip_h = false
	elif facing < 0:
		$AnimatedSprite2D.flip_h = true
		
	apply_pre_state_change(delta)	
	apply_state_change()


func apply_movement(delta: float) -> void:
	var direction: Vector2 = controller.get_direction()
	var horizontal_direction: float = controller.get_horizontal_direction()
	var should_jump: bool = controller.should_jump()
	
	# Apply movement speed
	if flying:
		velocity = direction * speed
	else:
		velocity.x = horizontal_direction * speed
		
		if is_on_floor():
			if should_jump and jump_strength > 0:
				velocity.y = -jump_strength
			else:
				velocity.y = 0
		else:
			velocity.y += get_gravity().y * delta

func apply_post_movement(delta: float) -> void:
	pass

func apply_pre_state_change(delta: float) -> void:
	pass

func apply_state_change() -> void:
	var horizontal_direction: float = controller.get_horizontal_direction()
	#var should_jump: bool = controller.should_jump()
	var should_attack: bool = controller.should_attack()

	# Change state if allowed
	if not attacking and not specialing:
		if should_special and animation_player.has_animation(&"special"):
			specialing = true
			facing_locked = true
			animation_player.play(&"special")
		elif should_attack and animation_player.has_animation(&"attack"):
			attacking = true
			#facing_locked = true
			animation_player.play(&"attack")
		elif is_on_floor() or flying:
			if horizontal_direction != 0 and animation_player.has_animation(&"run"):
				animation_player.play(&"run")
			else:
				animation_player.play(&"idle")
		elif velocity.y > 0 and animation_player.has_animation(&"fall"):
			animation_player.play(&"fall")
		else:
			animation_player.play(&"jump")


func take_damage(damage: float):
	health = max(0, health - damage)
	emit_signal("damaged")
	if health <= 0:
		emit_signal("death")
		queue_free()


# When an animation finishes, return to base state
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	animation_player.play(&"RESET")
	animation_player.advance(0)
	
	facing_locked = false
	if anim_name == "attack":
		attacking = false
	elif anim_name == "special":
		specialing = false
