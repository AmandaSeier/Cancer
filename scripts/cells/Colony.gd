extends Node2D
class_name Colony

@export var active: bool = false

var sprite: Sprite2D

var _rng = RandomNumberGenerator.new()


func _ready():
    sprite = get_node("Sprite2D")
    StateMachine.OnNextDay.connect(_TrySpread)
    StateMachine.colonies.append(self)

    if active:
        ActivateColony()


func ActivateColony() -> void:
    active = true
    sprite.visible = true


func KillColony() -> void:
    active = false
    sprite.visible = false


func _TrySpread() -> void:
    if not active:
        return

    for colony in StateMachine.colonies:
        var spreadRange: float = StateMachine.upgradeHandler.GetUpgradeValues()["range"]
        if self.position.distance_to(colony.position) <= spreadRange:
            colony.TryGrow()


# When being spread to, try and grow
func TryGrow() -> void:
    var growChance = StateMachine.upgradeHandler.GetUpgradeValues()["grow_chance"]
    if _rng.randf_range(0.0, 100.0) < growChance:
        ActivateColony()

