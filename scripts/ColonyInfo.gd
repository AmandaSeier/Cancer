extends ColorRect

@onready var colonyInfo := $/root/Node2D/UI_Handler/ColonyInfo
@onready var colonyInfoNode := get_node(colonyInfo.get_path())
@onready var coloni

# Called when the node enters the scene tree for the first time.
func _ready():
	colonyInfo.hide()
	
	for child in StateMachine.colonies:
		coloni = child
		child.connect("pressed", _UpdateLabel.bind(child))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var coloniSize = coloni.size / 2
	var mousePos = get_viewport().get_mouse_position()
	coloni.global_position = mousePos - coloniSize
	
	
	
func _UpdateLabel(colony):
	if colonyInfo.visible:
		colonyInfo.hide()
	else:
		colonyInfo.show()
	
	
	colonyInfoNode.global_position = _CalcOffset(colony)
	


func _CalcOffset(colony) -> Vector2:
	var constOffset = Vector2(50, 25)
	var variableOffset: Vector2 = colonyInfoNode.size / 2
	var totalOffset: Vector2 
	var colonyPos: Vector2 = colony.global_position
	var colonySize: Vector2 = colony.size
	var viewPortSize: Vector2 =  get_viewport_rect().size
	
	if colonyPos[0] > viewPortSize[0] / 2:
		constOffset[0] = -constOffset[0]
	if colonyPos[1] < viewPortSize[1] / 2:
		constOffset[1] = -constOffset[1]
		
	totalOffset = variableOffset + constOffset
	position = (colonyPos + colonySize / 2) - totalOffset
	print(colony.global_position)
	print(position)
	
	return position
	
	
	
	
