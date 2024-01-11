extends ColorRect

@onready var colonyInfo := get_node(".")
@onready var colonyName := get_node("ColonyName")
@onready var colonyInformation := get_node("ColonyName/ColonyInformation")

@onready var colonyGroup := get_node("../Colonies")

var highlightedColonyStr: String = ""
var highlightedColonyNode: Colony = null

var colonyInfoText: Dictionary = {
    "Size": "0 k",
    "Growth Speed": 0,
    "Organ Damage": 0,
    }


# Called when the node enters the scene tree for the first time.
func _ready():
    for organ in colonyGroup.get_children():
        for child in organ.get_children():
            child.connect("pressed", _UpdateLabelPos.bind(child))
    
    StateMachine.OnNextDay.connect(_UpdateLabelText)


# Updates the positioning and textual contents of the colony info box.
func _UpdateLabelPos(colony):
    if colony.get_name() == highlightedColonyStr:
        colonyInfo.visible = false
        highlightedColonyStr = ""
        return
    colonyInfo.visible = true
    highlightedColonyStr = colony.get_name()
    highlightedColonyNode = colony
    
    _UpdateLabelText()
    colonyInfo.global_position = _CalcOffset(colony)


func _UpdateLabelText():
    if highlightedColonyNode == null:
        return
    
    # Update values in the colony info dictionary
    colonyInfoText["Size"] = str(highlightedColonyNode.colonySize / 1000) + " Mil"
    colonyInfoText["Growth Speed"] = str(highlightedColonyNode.GetGrowth() as int) + " K/day"
    
    # Append the values in the colony info dictionary to a string
    var labelStr: String = ""
    for key in colonyInfoText.keys():
        var keyStr: String = "{key}: {information}\n"
        labelStr += keyStr.format({"key": str(key), "information": str(colonyInfoText[key])})
    
    # Update the label with the string
    colonyName.text = str(highlightedColonyNode.get_name())
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
