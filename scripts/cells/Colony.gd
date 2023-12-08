extends Node2D
class_name Colony

@export var active: bool = false

var sprite: Sprite2D

<<<<<<< HEAD
var _rng = RandomNumberGenerator.new()


=======
var _growChance: float = 6.9
var _rng = RandomNumberGenerator.new()

>>>>>>> 6259d92 (<commiring so that i can pull :(>)
func _ready():
	sprite = get_node("Sprite2D")
	StateMachine.OnNextDay.connect(_TrySpread)
	StateMachine.colonies.append(self)

	if active:
		ActivateColony()

<<<<<<< HEAD

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
=======
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
>>>>>>> 6259d92 (<commiring so that i can pull :(>)
		ActivateColony()

