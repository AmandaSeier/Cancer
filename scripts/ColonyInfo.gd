extends ColorRect

@onready var colonyInfo := get_node(".")
@onready var colonyName := get_node("ColonyName")
@onready var colonyInformation := get_node("ColonyName/ColonyInformation")

@onready var colonyGroup := get_node("../Colonies")

var highlightedColony: String = ""

var colonyInfoText: Dictionary = {
	"Size": 0,
	"GrowthSpeed": 0,
	"OrganDamage": 0
	}


# Called when the node enters the scene tree for the first time.
func _ready():
	for organ in colonyGroup.get_children():
		for child in organ.get_children():
			child.connect("pressed", _UpdateLabel.bind(child))


# Updates the positioning and textual contents of the colony info box.
func _UpdateLabel(colony):
	if colony.get_name() == highlightedColony:
		colonyInfo.visible = false
		highlightedColony = ""
		return
	colonyInfo.visible = true
	highlightedColony = colony.get_name()
	
	colonyInfo.global_position = _CalcOffset(colony)
	

	var labelStr: String = ""
	for key in colonyInfoText.keys():
		print(key)
		var keyStr: String = "{key}: {information}\n"
		labelStr += keyStr.format({"key": str(key), "information": str(colonyInfoText[key])})
	
	colonyName.text = str(colony.get_name())
	colonyInformation.text = str(labelStr)


# Calculates the positioning of the colonyinfo box.
func _CalcOffset(colony) -> Vector2:
	var constOffset             = Vector2(50, 25)
	var variableOffset: Vector2 = colonyInfo.size / 2
	var totalOffset: Vector2
	var colonyPos: Vector2      = colony.global_position
	var colonySize: Vector2     = colony.size
	var viewPortSize: Vector2   = get_viewport_rect().size
	
	if colonyPos[0] > viewPortSize[0] / 2:
		constOffset[0] = -constOffset[0]
	if colonyPos[1] < viewPortSize[1] / 2:
		constOffset[1] = -constOffset[1]
		
	totalOffset = variableOffset + constOffset
	var finalPos = (colonyPos + colonySize / 2) - totalOffset
	
	return finalPos
