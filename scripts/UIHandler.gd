extends Node

func ChangeDaySpeed(speed: float):
	StateMachine.ChangeDaySpeed(speed)

func StopDayCycle():
	StateMachine.StopDayCycle()

func _on_pause_menu_button_pressed():
	get_tree().change_scene_to_file("res://pause_menu.tscn")
