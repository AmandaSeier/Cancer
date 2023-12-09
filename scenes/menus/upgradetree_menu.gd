extends Control

@onready var upgradeTitle := $ColorRect/upgradeTitle
@onready var upgradeDescription := $ColorRect/upgradeDescription
@onready var buyButton := $ColorRect/buyButton

var upgradeInfo: Dictionary = {
	"Default": {
		"Description": "Unlock your first cancer colony.",
		"State": "Locked",
		"Price": 10
	},
	"Giga Growth": {
		"Description": "Increase the growth-rate of your cancer by xxx.",
		"State": "Locked",
		"Price": 10	
	},
	"Lymph Nodes": {
		"Description": "Gain access to the lymph nodes.",
		"State": "Locked",
		"Price": 10
	},
	"Medical Resistance": {
		"Description": "Become more resistant to cancer treatment.",
		"State": "Locked",
		"Price": 10
	}}


var nonUpgradeButtons: Array = ["back button", "buyButton"]


# Called when the node enters the scene tree for the first time.
func _ready():
	upgradeTitle.hide()
	upgradeDescription.hide()
	
	for child in $Background.get_children(): 
		if child is TextureButton and not nonUpgradeButtons.has(child):
			child.connect("pressed", _updateLabel.bind(child.get_name())) 
	
	buyButton.connect("pressed", Economy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_button_pressed():
	get_tree().change_scene_to_file(StateMachine.previousScene)


func _updateLabel(button):
	if upgradeInfo[button]["State"] == "Locked":
		upgradeTitle.text = "Locked"
		upgradeDescription.text = "Locked"
		_showLabels()
		return
	
	upgradeTitle.text = upgradeInfo[button]
	upgradeDescription.text = upgradeInfo[button]["Description"]
	print(buyButton.text)
	_showLabels()
	

func _showLabels():
	upgradeTitle.show()
	upgradeDescription.show()

func _hideLabel():
	upgradeTitle.hide()
	upgradeDescription.hide()
	
	
func tryBuy():
	print("You've clicked me")


