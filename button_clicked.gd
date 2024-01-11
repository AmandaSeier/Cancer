extends AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready():
    stop()

var active := true

func turnOnOffSounds():
    active = !active

func playSoundEffect():
    if active:
        play()


 
