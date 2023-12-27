extends ColorRect

@onready var colonyInfo := $/root/Node2D/UI_Handler/ColonyInfo

# Called when the node enters the scene tree for the first time.
func _ready():
	colonyInfo.hide()
	
	for child in StateMachine.colonies:
		print(child)
		child.connect("pressed", _UpdateLabel.bind(child))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func _UpdateLabel(colony):
	if colonyInfo.visible:
		colonyInfo.hide()
	else:
		colonyInfo.show()
	
	get_node(colonyInfo.get_path()).global_position = colony.global_position - Vector2(0, 0)
	
	print(colony.global_position)


func _CalcOffset(colony) -> Vector2:
	var constOffset = Vector2(50, 50)
	var variableOffset: Vector2
	var totalOffset: Vector2
	
	
	totalOffset = constOffset + variableOffset
	return totalOffset
	
	
	
	
