extends TextureButton
class_name Colony

enum Organ {
    Heart,
    Lungs,
    Liver,
    Intestines,
    Brain,
}

@export var active: bool = false
@export var organ: Organ

var colonySize: int = 0
const activationSize: int = 300000

# hard coded growth value for the growth function. needs to be manually changed :(
const growthConstant = 0.0033
const maxSizeMargin = 50000 # In order to avoid infinite values from the growth curve


func _ready():
    StateMachine.OnNextDay.connect(_UpdateColony)
    StateMachine.colonies.append(self)

    if active:
        ActivateColony()
        colonySize = activationSize + 100000


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

func ActivateColony():
    active = true
    visible = true


func KillColony():
    active = false
    visible = false


func _UpdateColony():
    colonySize += round(GetGrowth())
    var maxSize: int = StateMachine.upgradeHandler.GetUpgradeValues()["max_size"]
    colonySize = clamp(colonySize, 0, maxSize)
    
    if (colonySize < activationSize):
        KillColony()
        return

    _TrySpread()


func _TrySpread():
    if not active:
        return

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
func Spread():
    var growth = StateMachine.upgradeHandler.GetUpgradeValues()["spread_amount"] * (1. / (1. + (active as float) * 3))
    colonySize += growth

    if (colonySize >= activationSize):
        ActivateColony()

