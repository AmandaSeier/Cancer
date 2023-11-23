extends Node

# Timer and day counter
var _dayTimer: Timer
var _dayCount: int = 0

var colonies: Array[Colony]
var upgrades: Dictionary = {"range": 50}
	
signal OnNextDay

# Called when the node enters the scene tree for the first time.
func _ready():
	# Start the day timer
	_dayTimer = Timer.new()
	_dayTimer.wait_time = 1
	add_child(_dayTimer)
	_dayTimer.start()
	_dayTimer.timeout.connect(_IncementDayCounter)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _IncementDayCounter():
	_dayCount += 1
	print(_dayCount)
	OnNextDay.emit()


func ChangeDaySpeed(speed: float):
	# This updates the timers speed immediatly
	var timeRatio = _dayTimer.wait_time / (1 / speed)
	_dayTimer.wait_time = _dayTimer.time_left / timeRatio  # This scales the remaining time by ratio
	_dayTimer.stop()
	_dayTimer.start()  # restart the timer with the new remaining time
	_dayTimer.wait_time = 1 / speed  # set the timer to it's actual speed
