extends Control

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/Louis - Test Scenes/Louis Main 2.tscn")

func _on_levels_pressed():
	get_tree().quit()

func _on_quit_pressed():
	get_tree().change_scene_to_file("res://Scenes/Louis - Test Scenes/levels.tscn")
