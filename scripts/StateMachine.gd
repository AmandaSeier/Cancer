extends Node

# Timer and day counter
var _dayTimer: Timer
var _dayCount: int = 0

var upgradeHandler: UpgradeHandler = UpgradeHandler.new({
    "colonyRange": {
        "base": 40.,
        "spread1": 5.,
        "spread2": 5.,
        "spread3": 5.,
        "bigger_colonies": 10.
    }, # colonyRange
    "max_size": {
        "base": 750.,
        "bigger_colonies": 1500., # duplicate upgrade name means it changes 3 stats
    }, # max size
    "grow_chance": {
        "base": 3.,
        "larger_blood_supply": 1.,
        "bigger_colonies": -1.,
    }, # grow chance
    })

var colonies: Array[Colony] # used to refrence colonies outside of script (is in use)
	
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

func StopDayCycle():
	_dayTimer.stop()
