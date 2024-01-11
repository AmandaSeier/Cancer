extends Node


func _ready():
    StateMachine.StopDayCycle()
    
    # Upgrade tree scene
    get_node("UpgradeMenu/Background/backButton").connect("pressed", backButtonPressed)
    get_node("PauseMenu/CenterContainer/VBoxContainer/Resume button").connect("pressed", backButtonPressed)
    

func ChangeDaySpeed(speed: float):
    StateMachine.ChangeDaySpeed(speed)
   

func _on_pause_menu_button_pressed():
    get_node("Pause button").button_pressed = true
    get_node("PauseMenu").visible = true


func _on_upgrade_pressed():
    get_node("Pause button").button_pressed = true
    get_node("UpgradeMenu").visible = true


func backButtonPressed():
    get_node("PauseMenu").visible = false
    get_node("UpgradeMenu").visible = false


func _on_pause_button_toggled(button_pressed):
    StateMachine.StopDayCycle()


func _on_info_icon_pressed():
    get_node("Pause button").button_pressed = true
    get_node("CancerInfo").visible = true
