extends Control

@onready var upgradeTitle := $UpgradeDescriptionBox/upgradeTitle
@onready var upgradeDescription := $UpgradeDescriptionBox/upgradeDescription
@onready var buyButton := $UpgradeDescriptionBox/buyButton
@onready var upgradeDescriptionBox := $UpgradeDescriptionBox
@onready var borderRing := $UpgradeDescriptionBox/BorderRing
@onready var backButton := $Background/backButton


var nonUpgradeableButtons: Array = [backButton, buyButton]


# Called when the node enters the scene tree for the first time.
func _ready():
	_HideUpgradeDescriptionBox()
	
	for child in $Background.get_children(): 
		if child is TextureButton and child.get_name() != "backButton":
			child.connect("pressed", _UpdateLabel.bind(child.get_name())) 
	
	buyButton.connect("pressed", _TryBuy)
	
	for key in StateMachine.upgradeUIInfo.keys():
		var value = StateMachine.upgradeUIInfo[key]
		if value["State"] == "Bought":
			_BoughtUpgradeTexture(key)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_button_pressed():
	get_tree().change_scene_to_file(StateMachine.previousScene)


func _UpdateLabel(button):
	for item in StateMachine.upgradeUIInfo.values():
		item["Active"] = false
	StateMachine.upgradeUIInfo[button]["Active"] = true
	
	borderRing.global_position = get_node("Background/" + str(button)).global_position
	
	if StateMachine.upgradeUIInfo[button]["State"] == "Locked":
		upgradeTitle.text = "Locked"
		upgradeDescription.text = "Locked"
		_ShowUpgradeDescriptionBox()
		return
	
	upgradeTitle.text = str(button)
	upgradeDescription.text = str(StateMachine.upgradeUIInfo[button]["Description"])
	
	
	_ShowUpgradeDescriptionBox()
	

func _ShowUpgradeDescriptionBox():
	upgradeDescriptionBox.show()

func _HideUpgradeDescriptionBox():
	upgradeDescriptionBox.hide()
	
	
	

func _TryBuy():
	for key in StateMachine.upgradeUIInfo.keys():
		var item = StateMachine.upgradeUIInfo[key]
		
		if item["Active"] and item["State"] == "Unlocked":
			if item["Price"] > StateMachine.cancerPoints:
				return
				
			item["State"] = "Bought"
			StateMachine.cancerPoints -= item["Price"]
			
			_BoughtUpgradeTexture(key)
			return


func _BoughtUpgradeTexture(buttonname: String):
	var path = get_node("Background/" + str(buttonname))
	path.set_texture_normal(load("res://sprites/upgradetree related/" + buttonname + " - Bought.png"))


