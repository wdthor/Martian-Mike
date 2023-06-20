extends Control


func _on_button_pressed():
	# Go back to level 1
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
