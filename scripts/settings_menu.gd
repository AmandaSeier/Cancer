extends Control


func _on_back_pressed():
    self.visible = false


func _on_music_toggled(button_pressed):
    BgMusic.toggleMusic()


func _on_sound_toggled(button_pressed):
    print("i am not currently doing anything, Find me and make me do stuff :P")
