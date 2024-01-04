extends Sprite2D

var _health: float = 100.

# Called when the node enters the scene tree for the first time.
func _ready():
	StateMachine.OnNextDay.connect(_calcHealth)	


func _calcHealth():
	if _health != 0:
		_health -= StateMachine.upgradeHandler.GetUpgradeValues()["damage_multiplyer"]
		print("Health: ", _health)
		scale.x = _health * 0.005
	else:
		_health = 0
		print("You lost. You so bad. Buhuuu loser")
	
	
	
