class_name Player
extends Node2D

signal damaged
signal death

@onready var slots: Array[CharacterBody2D] = [$Sewling, $Sewfly]
@onready var current_slot_id: int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# disable all slots except the first one
	for i in range(len(slots)):
		slots[i].controller = $PlayerController
		slots[i].connect("damaged", on_damaged)
		slots[i].connect("death", on_death)

		if i > 0:
			slots[i].visible = false
			slots[i].process_mode = PROCESS_MODE_DISABLED
			slots[i].set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var input_switch_1 = Input.is_action_pressed("switch_1")
	var input_switch_2 = Input.is_action_pressed("switch_2")
	var input_switch_3 = Input.is_action_pressed("switch_3")
	var input_switch_4 = Input.is_action_pressed("switch_4")
	
	if input_switch_1:
		switch_to_slot(0)
	elif input_switch_2:
		switch_to_slot(1)
	elif input_switch_3:
		switch_to_slot(2)
	elif input_switch_4:
		switch_to_slot(3)
		
func switch_to_slot(slot_id: int) -> void:
	if slot_id >= len(slots) or current_slot_id == slot_id:
		return
	if not is_instance_valid(slots[slot_id]):
		return
	
	var health_percentage: float = slots[current_slot_id].health / slots[current_slot_id].max_health
	var current_position = slots[current_slot_id].position
	var current_velocity = slots[current_slot_id].velocity
	print(current_velocity)
	
	slots[current_slot_id].visible = false
	slots[current_slot_id].process_mode = Node.PROCESS_MODE_DISABLED

	slots[slot_id].process_mode = Node.PROCESS_MODE_INHERIT
	slots[slot_id].visible = true
	
	slots[slot_id].position = current_position
	slots[slot_id].velocity = current_velocity
	# keep the health percentage equal between switches
	slots[slot_id].health = health_percentage * slots[slot_id].max_health
	# change signal to health changed or smth
	emit_signal("damaged")
	
	current_slot_id = slot_id

func on_damaged():
	print("Player took damage!")
	emit_signal("damaged")
	
func on_death():
	emit_signal("death")

func get_player_position() -> Vector2:
	if not is_instance_valid(slots[current_slot_id]):
		return Vector2.ZERO
		
	return slots[current_slot_id].global_position
	
func get_health() -> float:
	if not is_instance_valid(slots[current_slot_id]):
		return 0
		
	return slots[current_slot_id].health

func get_max_health() -> float:
	if not is_instance_valid(slots[current_slot_id]):
		return 0
		
	return slots[current_slot_id].max_health
