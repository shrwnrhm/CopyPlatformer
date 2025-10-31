extends Node2D

func game_over():
	$CanvasLayer/GameOverMenu.visible = true
	
#func reset():
	#get_tree().reload_current_scene()
	
#func exit():
	#get_tree().quit()

func _on_player_death() -> void:
	game_over()
