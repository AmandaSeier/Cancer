extends Node

var _dayTimer: Timer
var _dayCount: int = 0

signal OnNextDay

# Called when the node enters the scene tree for the first time.
func _ready():
    _dayTimer = Timer.new()
    _dayTimer.autostart = true
    _dayTimer.wait_time = 1
    add_child(_dayTimer)
    _dayTimer.timeout.connect(_IncementDayCounter)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass


func _IncementDayCounter():
    _dayCount += 1
    print(_dayCount)
    OnNextDay.emit()
