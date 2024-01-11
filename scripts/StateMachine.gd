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
        "Lymph Nodes": 10.,
    }, # colonyRange
    "max_size": { # max number of cells in colony
        "base": 3_000_000.,
    }, # max size
    "growth_multiplier": {
        "base": 1.,
        "Giga Growth": .2,
    }, # growth multiplier
    "spread_amount": { # Amount of cells colonies spread to adjesant colonies pr. day
        "base": 2000.,
        "Giga Growth": 250.,
    }, # spread amount
    "growth_decrease": { # cells pr. day
        "base": 1000.,
    }, # growth decrease
    "damage_multiplyer": {
        "base": 1.,
    }, # damage multiplier
}

var upgradeUIInfo: Dictionary = {
    "Default": {
        "Description": "Unlock your first cancer colony.",
        "State": "Unlocked", # Three states: Locked, unlocked and bought.
        "Cost": 0.,
        "Active": false
    },
    "Giga Growth": {
        "Description": "Increase the growth-rate of your cancer by 150 K cells/day.",
        "State": "Unlocked",
        "Cost": 100.,
        "Active": false
    },
    "Lymph Nodes": {
        "Description": "Gain access to the lymph nodes. Increase your colonies spread reach.",
        "State": "Unlocked",
        "Cost": 100.,
        "Active": false
    },
    "Medical Resistance": {
        "Description": "Become more resistant to cancer treatment.",
        "State": "Unlocked",
        "Cost": 100.,
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
    # print("Day: ", _dayCount)
    get_node("/root/MainScene/UiHandler/dayCount").text = "Day: " + str(_dayCount)
    OnNextDay.emit()


func ChangeDaySpeed(speed: float):
    # This updates the timers speed immediatly
    var timeRatio = _dayTimer.wait_time / (1 / speed)
    _dayTimer.wait_time = _dayTimer.time_left / timeRatio  # This scales the remaining time by ratio
    _dayTimer.stop()
    _dayTimer.start()  # restart the timer with the new remaining time
    _dayTimer.wait_time = 1 / speed  # set the timer to it's actual speed


func GetCurrentDay() -> int:
    return _dayCount


func GetTotalNumCells() -> int:
    var numCells := 0
    for colony in colonies:
        numCells += colony.colonySize

    return numCells


func GetActiveColonies() -> Array[Colony]:
    var activeColonies: Array[Colony] = []
    for colony in colonies:
        if colony.active:
            activeColonies.append(colony)

    return activeColonies


var _previousDayCells := 0
func GetTotalGrowth() -> int:
    var change = GetTotalNumCells() - _previousDayCells
    _previousDayCells = GetTotalNumCells()
    return change


func StopDayCycle():
    _dayTimer.stop()


func ResumeDayCycle():
    _dayTimer.start()


func Restart():
    _previousDayCells = 0
    colonies = []
