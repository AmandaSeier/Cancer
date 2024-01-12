extends Control


func _on_restart_pressed():
    StateMachine.Restart()
    get_tree().change_scene_to_file("res://scenes/Main_Scene.tscn")
    Sfx.playSoundEffect()
