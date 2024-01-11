extends TextureButton
class_name Colony

enum Organ {
    Heart,
    Lungs,
    Liver,
    Intestines,
    Brain,
}

@export var active := false
@export var organ: Organ

var colonySize := 0
const activationSize := 300000

# hard coded growth value for the growth function. needs to be manually changed :(
const growthConstant := 0.0045
const maxSizeMargin := 50000 # In order to avoid infinite values from the growth curve


func _ready() -> void:
    StateMachine.OnNextDay.connect(_UpdateColony)
    StateMachine.colonies.append(self)

    if active:
        ActivateColony()
        colonySize = activationSize + 100_000


func _CalcCurveX_0() -> float:
    var maxSize: float = StateMachine.upgradeHandler.GetUpgradeValues()["max_size"] + maxSizeMargin
    var multiplier: float = StateMachine.upgradeHandler.GetUpgradeValues()["growth_multiplier"]
    
    var x_0 = log(maxSize / activationSize - 1) / growthConstant * multiplier
    return x_0


func _CalcGrowthCurve(time: float) -> float:
    # max / (1 + e^(-k * (x - x_0)))
    var maxSize: float = StateMachine.upgradeHandler.GetUpgradeValues()["max_size"] + maxSizeMargin
    const e: float = 2.718281828459045
    var multiplier: float = StateMachine.upgradeHandler.GetUpgradeValues()["growth_multiplier"]

    return maxSize / (1+pow(e, (-growthConstant * multiplier) * (time - _CalcCurveX_0())))


func _SizeToCurveTime(x: float) -> float:
    var maxSize: float = StateMachine.upgradeHandler.GetUpgradeValues()["max_size"] + maxSizeMargin
    var multiplier: float = StateMachine.upgradeHandler.GetUpgradeValues()["growth_multiplier"]

    return _CalcCurveX_0() - (log(maxSize / x - 1) / (growthConstant * multiplier))


func GetGrowth() -> float:
    var nextSize = _CalcGrowthCurve(_SizeToCurveTime(colonySize) + 1)
    var increase = nextSize - colonySize
    var decrease = StateMachine.upgradeHandler.GetUpgradeValues()["growth_decrease"]
    
    return increase * (active as int) - decrease

func ActivateColony() -> void:
    active = true
    visible = true


func KillColony() -> void:
    colonySize = 0
    _DeactivateColony()

func _DeactivateColony() -> void:
    active = false
    visible = false


func DamageColony(dmg: int) -> void:
    if (colonySize < dmg):
        KillColony()
        return

    colonySize -= dmg


func _UpdateColony() -> void:
    colonySize += round(GetGrowth())
    var maxSize: int = StateMachine.upgradeHandler.GetUpgradeValues()["max_size"]
    colonySize = clamp(colonySize, 0, maxSize)
    
    if (colonySize < activationSize):
        _DeactivateColony()
        return

    if active:
        _TrySpread()


func _TrySpread() -> void:
    for colony in StateMachine.colonies:
        if colony == self:
            continue

        var colonyRange = StateMachine.upgradeHandler.GetUpgradeValues()["range"]
        if not position.distance_to(colony.position) <= colonyRange:
            continue

        if colony.organ != organ && not StateMachine.upgradeHandler.IsUpgraded("organ_spread"):
            continue

        colony.Spread()


# When being spread to
func Spread() -> void:
    var growth = StateMachine.upgradeHandler.GetUpgradeValues()["spread_amount"] * (1. / (1. + (active as float) * 3))
    colonySize += growth
    print("New size is: ", colonySize)

    if (colonySize >= activationSize):
        ActivateColony()

