extends Node

# Global variables
var colonies: Array[Colony] = [] # used to refrence colonies outside of script (is in use)
var cancerPoints: float = 100.


# Timer and day counter
var _dayTimer: Timer
var _dayCount: int = 0

var upgradeInfo: Dictionary = {
	"range": { # magical game units (aka. mayhaps pixels)
		"base": 40.,
		"spread1": 5.,
		"spread2": 5.,
		"spread3": 5.,
		"bigger_colonies": 10.
	}, # colonyRange
	"max_size": { # max number of cells in colony
		"base": 1_000_000.,
		"bigger_colonies": 1_500_000., # duplicate upgrade name means it changes multiple stats
	}, # max size
	"growth_multiplier": {
		"base": 1.,
		"larger_blood_supply": .1,
		"bigger_colonies": -.1,
		"Giga Growth": .2,
		"cigarettes": 0.1,
	}, # growth multiplier
	"spread_amount": { # Amount of cells colonies spread to adjesant colonies pr. day
		"base": 0.,
	}, # spread amount
	"growth_decrease": { # cells pr. day
		"base": 1000,
	}, # growth decrease
	"damage_multiplyer": {
		"base": 1.,
		"cigarettes": .2,
		"alcohol": .1,
	}, # damage multiplier
	"misc.": {
		"brain": 0,
		"organ_spread": 0
	}, # misc
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


var colonyInfo: Dictionary = {}

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


func _IncementDayCounter():
	_dayCount += 1
	print("Day: ", _dayCount)
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


func ResumeDayCycle():
	_dayTimer.start()


