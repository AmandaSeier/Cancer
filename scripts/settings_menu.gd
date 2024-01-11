extends Control


func _on_back_pressed():
    self.visible = false
    Sfx.playSoundEffect()


func _on_music_toggled(button_pressed):
    BgMusic.toggleMusic()


func _on_sound_toggled(button_pressed):
    Sfx.turnOnOffSounds()
