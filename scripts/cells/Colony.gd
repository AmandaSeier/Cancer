extends Node2D
class_name Colony

@export var active: bool = false

var sprite: Sprite2D

var _growChance: float = 6.9
var _rng = RandomNumberGenerator.new()

func _ready():
	sprite = get_node("Sprite2D")
	StateMachine.OnNextDay.connect(_TrySpread)
	StateMachine.OnNextDay.connect(_TrySpread)
	StateMachine.colonies.append(self)

	if active:
		ActivateColony()

func ActivateColony():
	active = true
	sprite.visible = true

func KillColony():
	active = false
	sprite.visible = false

func _TrySpread():
	if not active:
		return


	for colony in StateMachine.colonies:
		if colony == self:
			continue

		if self.position.distance_to(colony.position) <= StateMachine.upgrades.get("range"):
			colony.TryGrow()

# When being spread to, try and grow
func TryGrow():
	if _rng.randf_range(0.0, 100.0) < _growChance:
		ActivateColony()

