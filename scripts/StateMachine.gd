extends Node

# Global variables
var previousScene: String = "" 
var colonies: Array[Colony] # used to refrence colonies outside of script (is in use)
var cancerPoints: float = 100.


# Timer and day counter
var _dayTimer: Timer
var _dayCount: int = 0

var upgradeInfo: Dictionary = {
	"range": {
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
	}
	}
	
var upgradeUIInfo: Dictionary = {
	"Default": {
		"Description": "Unlock your first cancer colony.",
		"State": "Unlocked", # Three states: Locked, unlocked and bought.
		"Price": 10.,
		"Active": false
	},
	"Giga Growth": {
		"Description": "Increase the growth-rate of your cancer by xxx.",
		"State": "Unlocked",
		"Price": 10.,
		"Active": false
	},
	"Lymph Nodes": {
		"Description": "Gain access to the lymph nodes.",
		"State": "Locked",
		"Price": 10.,
		"Active": false
	},
	"Medical Resistance": {
		"Description": "Become more resistant to cancer treatment.",
		"State": "Locked",
		"Price": 10.,
		"Active": false
	}
	}


var colonyInfo: Dictionary = {
	
}

var upgradeHandler: UpgradeHandler = UpgradeHandler.new(upgradeInfo)


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
	print(previousScene)
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


