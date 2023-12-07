extends Node

var _health: int = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	StateMachine.OnNextDay.connect(_calcHealth)

func _calcHealth():
	
	if _health != 0:
		_health -= 1
		print("Health   : ", _health)
	else:
		_health = 0
		print("You lost. You so bad. Buhuuu loser")
