extends CharacterBody2D

signal damaged
signal death

@export var speed: float = 200.0
@export var max_health: float = 20.0

@onready var is_attacking = false
@onready var is_specialing = false

@onready var facing: int = 1
@onready var facing_locked: bool = false

@onready var health: = max_health

@onready var controller = $AIController

func _ready() -> void:
	$AnimationPlayer.animation_finished.connect(_on_animation_player_animation_finished)

func _physics_process(delta: float) -> void:
	controller.calculate()
	
	var direction: Vector2 = controller.get_direction()
	var horizontal_direction: float = controller.get_horizontal_direction()
	var should_attack: bool = controller.should_attack()
	#velocity = direction * move_toward(velocity.length(), SPEED, delta) * delta
	velocity = direction * speed
	
	# Add the gravity.
	if not is_on_floor():
		# this creature can fly, so no gravity is applied
		#velocity += get_gravity() * delta
		pass
	
	if not facing_locked:
		if horizontal_direction > 0:
			facing = 1
		elif horizontal_direction < 0:
			facing = -1
		
	move_and_slide()
		
	# Left/Right orientation of the sprite
	if facing > 0:
		$AnimatedSprite2D.flip_h = true
	elif facing < 0:
		$AnimatedSprite2D.flip_h = false
	
	
	if not is_attacking and not is_specialing:
		if should_attack:
			is_attacking = true
			#facing_locked = true
			$AnimationPlayer.play("attack")
		else:
			$AnimationPlayer.play("idle")
	
func take_damage(damage: float):
	health = max(0, health - damage)
	emit_signal("damaged")
	if health <= 0:
		emit_signal("death")
		queue_free()
		
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	is_attacking = false
	is_specialing = false
	facing_locked = false
