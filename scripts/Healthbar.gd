extends Sprite2D

var _health: float = 100.
var _dailyDamageTaken: float
var _dailyHealthGained: float


var _kemoActive: bool = false
@export var _kemoSandsynlighed: int = 50 # 1/50
@export var _kemoDageImellemEvents: int = 7 # 1 gang om ugen
@export var _kemoHealth: float = 5
@export var _kemoTotalEvents: int = 10
var _kemoFinishedEvents: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    StateMachine.OnNextDay.connect(_healthCalculations)	
    
    
func _healthCalculations():
    _randomPatientMoves()
    _calcHealthGained()
    _calcHealth()


func _randomPatientMoves():
    var number = RandomNumberGenerator.new()
    if !_kemoActive:
        if number.randi_range(0,_kemoSandsynlighed) == 1:
            # activate kemo if random number equals 1
            _kemoActive = true
            print("Patienten får nu kemo behandling en gang om ugen")

func _calcHealthGained():
    _dailyHealthGained = 0
    if _kemoActive:
        if _kemoFinishedEvents < _kemoTotalEvents:
            if !(StateMachine._dayCount % _kemoDageImellemEvents):
                _dailyHealthGained = _kemoHealth
                print("Patienten har nu været til kemo behandling")
                _kemoFinishedEvents += 1
        else:
            _kemoFinishedEvents = 0
            _kemoActive = false


func _calcHealth():
    _dailyDamageTaken = StateMachine.upgradeHandler.GetUpgradeValues()["damage_multiplyer"]
    
    if _health > 0:
        # Update the health variable 
        _health -= _dailyDamageTaken
        _health += _dailyHealthGained
        print("Health: ", _health)
        scale.x = _health * 0.1 # scale.x = 10 is the same as 100% health
        if _health >= 100:
            print("GAME OVER")
            # call game over scene
    else:
        _health = 0
        print("Yaiii you won")
        # call game won scene
    
    
    
