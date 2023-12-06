extends Sprite2D

var _health: int = 100
var _posX: int = 228
var _posY: int = 162

# Called when the node enters the scene tree for the first time.
func _ready():
	StateMachine.OnNextDay.connect(_calcHealth)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _calcHealth():
	_health -= 1
	print("Health: ", _health)
	scale.x = _health * 0.005
	
