extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	# Start playing when the game starts
	# this scene (BackgroundMusic) is autoloaded at the start of the game
	play()
	print("Playing music")
	
	# the music need to toogle depending on a signal
	# connect "toggleMusic" to this signal xxx


func toggleMusic():
	if playing:
		stop()
	else:
		play() 
