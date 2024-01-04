extends ColorRect

@onready var colonyInfo := $/root/Node2D/UI_Handler/ColonyInfo
@onready var colonyInfoNode := get_node("colo")
@onready var colonyName := $/root/Node2D/UI_Handler/ColonyInfo/ColonyName
@onready var colonyInformation := $/root/Node2D/UI_Handler/ColonyInfo/ColonyName/ColonyInformation

@onready var colonyGroup := $/root/Node2D/UI_Handler/Colonies


# Called when the node enters the scene tree for the first time.
func _ready():
	# colonyInfo.hide()
	"""
	for child in colonyGroup.get_children():
		child.connect("pressed", _UpdateLabel.bind(child))
	"""


# Updates the positioning and textual contents of the colony info box.
func _UpdateLabel(colony):
	if colonyInfo.visible:
		colonyInfo.hide()
		return
	else:
		colonyInfo.show()
	
	colonyInfoNode.global_position = _CalcOffset(colony)
	
	var labelStr: String = ""
	for key in StateMachine.colonies[colony.get_name()].keys():
		print(key)
		var keyStr: String = "{key}: {information}\n"
		labelStr += keyStr.format({"key": str(key), "information": str(StateMachine.colonies[colony.get_name()][key])})
	
	colonyName.text = str(colony.get_name())
	colonyInformation.text = str(labelStr)


# Calculates the positioning of the colonyinfo box.
func _CalcOffset(colony) -> Vector2:
	var constOffset 				= Vector2(50, 25)
	var variableOffset: Vector2 	= colonyInfoNode.size / 2
	var totalOffset: Vector2
	var colonyPos: Vector2 			= colony.global_position
	var colonySize: Vector2 		= colony.size
	var viewPortSize: Vector2 		= get_viewport_rect().size
	
	if colonyPos[0] > viewPortSize[0] / 2:
		constOffset[0] = -constOffset[0]
	if colonyPos[1] < viewPortSize[1] / 2:
		constOffset[1] = -constOffset[1]
		
	totalOffset = variableOffset + constOffset
	var finalPos = (colonyPos + colonySize / 2) - totalOffset
	
	return finalPos
