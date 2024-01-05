extends TextureButton
class_name Colony

@export var active: bool = false

var colonySize: int = 0

var _growthSpeed: float = 0
var _rng = RandomNumberGenerator.new()



func _ready():
    StateMachine.OnNextDay.connect(_TrySpread)
    StateMachine.colonies.append(self)

    if active:
        ActivateColony()


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

