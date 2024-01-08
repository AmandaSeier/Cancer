extends Control

var scrollIndex: int = 0
var scrollBy: int = 10

var initialPos: int = 0
var maxScroll: int = -100 # Subtracting from the position moves the content up.


func _ready():
    initialPos = get_node("Info").global_position[1]


func clampNodePos(val: int, minval: int, maxval: int, node):
    var nodePos = node.global_position
    if (nodePos[1] + val) < minval: return 0
    if (nodePos[1] + val) > maxval: return 0
    return val
    

func _input(event):
    if not event is InputEventMouseButton:
        return
    if not event.pressed:
        return
    
    scrollIndex = 0
    if event.button_index == MOUSE_BUTTON_WHEEL_UP:
            print("Wheel up")
            scrollIndex = scrollBy
    if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
            print("Wheel down") 
            scrollIndex = -scrollBy
    
    _updateInfoNodePos(clampNodePos(scrollIndex, maxScroll, initialPos, get_node("Info")))


func _updateInfoNodePos(offset: int):
    get_node("Info").global_position[1] += offset
