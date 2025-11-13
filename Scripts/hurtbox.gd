class_name Hurtbox
extends Area2D

func _init() -> void:
	collision_layer = 0x1000 # should be a 8 for collision layer 4
	collision_mask = 0x100 # should be a 4 for collision layer 3
	area_entered.connect(on_hitbox_entered)

func on_hitbox_entered(hitbox: Hitbox):
	if owner == hitbox.owner:
		return
		
	if owner.has_method("take_damage"):
		owner.call("take_damage", hitbox.damage)
	
	if owner.has_method("take_knockback"):
		var knockback_direction = (owner.global_position - hitbox.owner.global_position).normalized()
		owner.call("take_knockback", knockback_direction * hitbox.knockback_strength)
