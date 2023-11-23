extends Node
class_name Colony

var sprite: Sprite2D

var active: bool = false

func _ready():
	sprite = get_node("Sprite2D")

func ActivateColony():
	active = true
	sprite.visible = true

func KillColony():
	active = false
	sprite.visible = false
