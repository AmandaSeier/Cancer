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

var _rng = RandomNumberGenerator.new()


func _ready():
    StateMachine.OnNextDay.connect(_TrySpread)
    StateMachine.colonies.append(self)

    if active:
        ActivateColony()


func GetGrowthSpeed():
    # Logistic growth curve
    #                Max
    #  f(x) =  ----------------
    #          1+e^(-k*(x-x_0))
    pass


func ActivateColony():
    active = true
    visible = true

func KillColony():
    active = false
    visible = false

func _TrySpread():
    if not active:
        return

    for colony in StateMachine.colonies:
        if colony == self:
            continue

        if self.position.distance_to(colony.position) <= StateMachine.upgradeHandler.GetUpgradeValues()["range"]:
            colony.TryGrow()


# When being spread to, try and grow
func TryGrow():
    if _rng.randf_range(0.0, 100.0) < StateMachine.upgradeHandler.GetUpgradeValues()["grow_chance"]:
        ActivateColony()

