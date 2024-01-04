extends Control





func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Main_Scene.tscn")


func _on_quit_button_pressed():
	get_tree().quit()


func _on_settings_button_pressed():
	get_node("SettingsMenu").visible = true


func backButtonPressed():
	get_node("SettingsMenu").visible = false
