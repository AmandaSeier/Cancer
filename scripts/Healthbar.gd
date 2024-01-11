extends Sprite2D

var _health := 100.

var frameIndex := 0
@export_category("Discorver cancer")
@export var _discoverCancerCellNum := 2_000_000

@export_category("Cancer damage")
@export_range(0, 1_000_000) var _minCellDmgNum := 0
@export_range(1_000_000, 7_500_000) var _maxCellDmgNum := 1_000_000
@export var _minDmg := 0.04
@export var _maxDmg := 1.
var _dmgPrDay := _minDmg

@export_category("cemo therapy")
@export var _cemoChance := 2. # in percent
@export var _cemoCooldownDays := 7 # 1 gang om ugen
@export var _cemoCancerDamage := 500_000
@export var _cemoCancerDmgVariation := 250_000
@export var _cemoDamage := 2.
@export var _cemoTotalEvents := 10
var _cemoActive := false
var _cemoFinishedEvents := 0

@export_category("Tumor removal operations")
@export var _operationCellNum := 3_000_000
@export var _operationCooldownDays := 60
var _operationDays := 0


@export_category("Messages")
@export var _HealthLabelPath: NodePath
var _HealthLabel: HealthEvent


var rng := RandomNumberGenerator.new()
var cancerFound := false

# Called when the node enters the scene tree for the first time.
func _ready():
    StateMachine.OnNextDay.connect(_HealthCalculations)	
    _HealthLabel = get_node(_HealthLabelPath)


func _HealthCalculations():
    _ActivateHealthEvents()
    _GetTreatment()
    _UpdateHealth()


func _ActivateHealthEvents() -> void:
    if not cancerFound:
        var num := rng.randf_range(0, 100)
        if num <= StateMachine.GetTotalNumCells() / (_discoverCancerCellNum as float):
            cancerFound = true
            _HealthLabel.NewMessage("The patiant knows he has cancer", 5)
            print("HE KNOWS PANIIIC!!")
        return

    var num := rng.randf_range(0, 100)
    # random events
    if num <= _cemoChance and not _cemoActive:
        _cemoActive = true
        _HealthLabel.NewMessage("Patient now gets cemo treatment once a week for 10 weeks", 5)
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
        colony.DamageColony(_cemoCancerDamage + randi_range(-_cemoCancerDmgVariation, _cemoCancerDmgVariation))

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
            _HealthLabel.NewMessage("Patient got an operation", 5)
        else:
            _operationDays += 1


func _UpdateHealth() -> void:
    if StateMachine.GetTotalNumCells() < _minCellDmgNum:
        _dmgPrDay = _minDmg
    elif StateMachine.GetTotalNumCells() > _maxCellDmgNum:
        _dmgPrDay = _maxDmg
    else:
        var t := (StateMachine.GetTotalNumCells() - _minCellDmgNum) / ((_maxCellDmgNum - _minCellDmgNum) as float)
        _dmgPrDay = lerpf(_minDmg, _maxDmg, t)

    var dailyDamageTaken: float = _dmgPrDay * StateMachine.upgradeHandler.GetUpgradeValues()["damage_multiplyer"]

    if _health > 0:
        # Update the health variable
        _health -= dailyDamageTaken
        # print("Health: ", _health)
        scale.x = _health * 0.048 # scale.x = 4.8 is the same as 100% health
        if StateMachine.GetActiveColonies().size() == 0:
            print("GAME OVER")
            # call game over scene
            StateMachine.StopDayCycle()
            get_tree().change_scene_to_file("res://scenes/gameover_screen.tscn")
    else:
        _health = 0
        print("Yaiii you won")
        # call game won scene
        StateMachine.StopDayCycle()
        get_tree().change_scene_to_file("res://scenes/winning_screen.tscn")

    
    for i in range(5):
        if _health < i * 20:
            get_node("../../Background_Stue").frame = 5 - i
            break

