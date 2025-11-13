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
@export var knockback_resistance: float = 8

@export var attack_cooldown: float = 0 # in seconds
@export var special_cooldown: float = 1 # in seconds

# Abilities
@export var flying: bool = false

# Changing Stats
@onready var health: float = max_health
@onready var gravity: float = 0
@onready var knockback: Vector2 = Vector2.ZERO

@onready var attack_cooldown_tracker: float = attack_cooldown
@onready var special_cooldown_tracker: float = special_cooldown

# State Trackers
@onready var jumping = false
@onready var attacking = false
@onready var specialing = false
@onready var facing: int = 1 if sprite_facing_right else -1 # -1: Left, 1: Right
@onready var facing_locked: bool = false

@onready var controller = $AIController
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# controller variables
@onready var direction: Vector2 = Vector2.ZERO
@onready var horizontal_direction: float = 0
@onready var should_attack: bool = false
@onready var should_special: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_player_animation_finished)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# update the time for the cooldowns
	attack_cooldown_tracker += delta
	special_cooldown_tracker += delta

	# Get the directives of the controller component
	controller.calculate()
	
	direction = controller.get_direction()
	horizontal_direction = controller.get_horizontal_direction()
	#var should_jump: bool = controller.should_jump()
	
	if attack_cooldown_tracker > attack_cooldown:
		should_attack = controller.should_attack()
		if should_attack:
			attack_cooldown_tracker = 0
	else:
		should_attack = false
		
	if special_cooldown_tracker > special_cooldown:
		should_special = controller.should_special()
		if should_special:
			special_cooldown_tracker = 0
	else:
		should_special = false
	
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
		take_damage(delta * max_health / 3)
		
	# Apply Left/Right orientation of the sprite
	if facing > 0:
		$AnimatedSprite2D.flip_h = false
	elif facing < 0:
		$AnimatedSprite2D.flip_h = true
		
	apply_pre_state_change(delta)	
	apply_state_change()


func apply_movement(delta: float, speed_multiplier: Vector2 = Vector2.ONE) -> void:
	var should_jump: bool = controller.should_jump()
	
	# Apply movement speed
	if flying:
		velocity = (direction * speed)
		velocity.x *= speed_multiplier.x
		velocity.y *= speed_multiplier.y
	else:
		velocity.x = horizontal_direction * speed
		velocity.x *= speed_multiplier.x
		velocity.y = 0

		if is_on_floor():
			gravity = 0
			if should_jump and jump_strength > 0:
				gravity -= jump_strength
		else:
			gravity += get_gravity().y * delta
			#print("gravity: ", gravity)
		velocity.y += gravity
			
	velocity += knockback
	knockback = knockback.lerp(Vector2.ZERO, knockback_resistance * delta)

func apply_post_movement(delta: float) -> void:
	pass

func apply_pre_state_change(delta: float) -> void:
	pass

func apply_state_change() -> void:
	#var should_jump: bool = controller.should_jump()

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

@onready var pop_label_scene = preload("res://Scenes/Effects/pop_label.tscn")
func take_damage(damage: float):
	health = max(0, health - damage)
	
	# create a pop label to indicate damage was received # TODO: use the signal instead
	var pop_label = pop_label_scene.instantiate()
	get_tree().root.add_child(pop_label)
	pop_label.pop(str(damage), global_position)

	emit_signal("damaged")
	if health <= 0:
		emit_signal("death")
		queue_free()


func take_knockback(knockback: Vector2):
	self.knockback += knockback


# When an animation finishes, return to base state
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	animation_player.play(&"RESET")
	animation_player.advance(0)
	
	facing_locked = false
	if anim_name == "attack":
		attacking = false
	elif anim_name == "special":
		specialing = false
