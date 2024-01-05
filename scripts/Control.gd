extends Node

@onready var colonyGroup := $/root/Node2D/UI_Handler/Colonies




# Called when the node enters the scene tree for the first time.
func _ready():
    """
    for colony in colonyGroup.get_children():
        StateMachine.colonies[colony.get_name()] = colonyInfo
    """

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
