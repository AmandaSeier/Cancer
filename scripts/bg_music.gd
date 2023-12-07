extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	# Start playing when the game starts
	# this scene (BackgroundMusic) is autoloaded at the start of the game
	play()
	print("PLaying music")
	
	# the music need to toogle depending on a signal
	# connect "_turnOnOffMusic" to this signal xxx


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _turnOnOffMusic():
	if playing:
		stop()
	else:
		play() 
