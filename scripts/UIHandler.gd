extends Node

func ChangeDaySpeed(speed: float):
	StateMachine.ChangeDaySpeed(speed)

func StopDayCycle():
	StateMachine.StopDayCycle()

func _on_pause_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/pause_menu.tscn")


func _on_upgrade_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/upgradetree_menu.tscn")
	StateMachine.previousScene = "res://scenes/Main_Scene.tscn"
