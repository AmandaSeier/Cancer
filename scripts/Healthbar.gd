extends Sprite2D

var _health := 100.

var frameIndex := 0

@export var _discoverCancerCellNum := 2_000_000

# Kemo
@export var _cemoChance := 2. # in percent
@export var _cemoCooldownDays := 7 # 1 gang om ugen
@export var _cemoCancerDamage := 500_000
@export var _cemoCancerDmg := 250_000
@export var _cemoDamage := 2.
@export var _cemoTotalEvents := 10
var _cemoActive := false
var _cemoFinishedEvents := 0

# Operation
@export var _operationCellNum := 3_000_000
@export var _operationCooldownDays := 60
var _operationDays := 0

const damagePrDay := 0.2
var rng := RandomNumberGenerator.new()
var cancerFound := false

# Called when the node enters the scene tree for the first time.
func _ready():
    StateMachine.OnNextDay.connect(_healthCalculations)	
    
    
func _healthCalculations():
    _ActivateHealthEvents()
    _GetTreatment()
    _UpdateHealth()


func _ActivateHealthEvents():
    if not cancerFound:
        var num := rng.randf_range(0, 100)
        if num <= StateMachine.GetTotalNumCells() / (_discoverCancerCellNum as float):
            cancerFound = true
            print("HE KNOWS PANIIIC!!")
        return

    var num := rng.randf_range(0, 100)
    # random events
    if num <= _cemoChance:
        _cemoActive = true
        print("He will now get cemo")


func _GetCemo() -> void:
    if not _cemoActive:
        return
        
    if not _cemoFinishedEvents < _cemoTotalEvents:
        _cemoFinishedEvents = 0
        _cemoActive = false
        return
    
    if StateMachine.GetCurrentDay() % _cemoCooldownDays != 0:
        return
        
    for colony in StateMachine.colonies:
        colony.DamageColony(_cemoCancerDamage + randi_range(-_cemoCancerDmg, _cemoCancerDmg))

    _health -= _cemoDamage

    _cemoFinishedEvents += 1
    print("Finished cemo event number ", _cemoFinishedEvents, " out of ", _cemoTotalEvents)


func _GetTreatment() -> void:
    if not cancerFound:
        return

    _GetCemo()

    # operation
    if StateMachine.GetTotalNumCells() > _operationCellNum:
        if _operationDays >= _operationCooldownDays:
            StateMachine.GetActiveColonies().pick_random().KillColony()
            _operationDays = 0
        else:
            _operationDays += 1


func _UpdateHealth():
    var dailyDamageTaken: float = damagePrDay * StateMachine.upgradeHandler.GetUpgradeValues()["damage_multiplyer"]
    
    if _health > 0:
        # Update the health variable 
        _health -= dailyDamageTaken
        print("Health: ", _health)
        scale.x = _health * 0.1 # scale.x = 10 is the same as 100% health
    else:
        _health = 0
        print("Yaiii you won")
        # call game won scene

    #######################################################################
    # PLEASE FJERN DET HER SENERE DET ER UDELUKKENDE FOR TEST AF BAGGRUNDE
    if StateMachine._dayCount / 20.0 == frameIndex+1:
        frameIndex += 1
        get_node("../../Background_Stue").frame = frameIndex
    #######################################################################

