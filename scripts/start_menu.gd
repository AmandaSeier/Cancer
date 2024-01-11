extends Control

func _ready():
    self.visible = true
    

func _on_start_button_pressed():
    Sfx.playSoundEffect()
    self.visible = false


func _on_quit_button_pressed():
    Sfx.playSoundEffect()
    get_tree().quit()


func _on_settings_button_pressed():
    Sfx.playSoundEffect()
    get_node("../SettingsMenu").visible = true  


func _on_credits_button_pressed():
    Sfx.playSoundEffect()
    print("I am cool credits button and i dont do anything. Put some credits in me.")
