extends Node


func _ready():
	print("HELLO")
	StateMachine.ResumeDayCycle()
	
	# Upgrade tree scene
	get_node("UpgradeMenu/Background/backButton").connect("pressed", backButtonPressed)
	get_node("PauseMenu/CenterContainer/VBoxContainer/Resume button").connect("pressed", backButtonPressed)
	
	# Settings menu scene
	# get_node("PauseMenu/CenterContainer/VBoxContainer/Resume button").connect("pressed", backButtonPressed)
	

func ChangeDaySpeed(speed: float):
	StateMachine.ChangeDaySpeed(speed)


func StopDayCycle():
	StateMachine.StopDayCycle()


func _on_pause_menu_button_pressed():
	get_node("PauseMenu").visible = true
	
	StateMachine.StopDayCycle()


func _on_upgrade_pressed():
	get_node("UpgradeMenu").visible = true
	
	StateMachine.StopDayCycle()


func backButtonPressed():
	get_node("PauseMenu").visible = false
	get_node("UpgradeMenu").visible = false
	
	StateMachine.ResumeDayCycle()
