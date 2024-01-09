extends Control

@onready var upgradeTitle := $UpgradeDescriptionBox/upgradeTitle
@onready var upgradeDescription := $UpgradeDescriptionBox/upgradeDescription
@onready var buyButton := $UpgradeDescriptionBox/buyButton
@onready var upgradeDescriptionBox := $UpgradeDescriptionBox
@onready var borderRing := $UpgradeDescriptionBox/BorderRing
@onready var backButton := $Background/backButton

var highlightedUpgrade = ""



# Called when the node enters the scene tree for the first time.
func _ready():
    upgradeDescriptionBox.visible = false
    
    for child in $Background.get_children(): 
        if child is TextureButton and child.get_name() != "backButton":
            child.connect("pressed", _UpdateLabel.bind(child.get_name())) 
    
    buyButton.connect("pressed", _TryBuy)
    

func _UpdateLabel(button):
    if button == highlightedUpgrade:
        upgradeDescriptionBox.visible = false
        highlightedUpgrade = ""
        return
    upgradeDescriptionBox.visible = true
    highlightedUpgrade = button
    
    _UpdateBorderRingPos(button)
    _UpdateBuyButton(button)
        
    if StateMachine.upgradeUIInfo[button]["State"] == "Locked":
        upgradeTitle.text = "Locked"
        upgradeDescription.text = "Locked"
        upgradeDescriptionBox.show()
        return
    upgradeTitle.text = str(button)
    upgradeDescription.text = str(StateMachine.upgradeUIInfo[button]["Description"])
    
    upgradeDescriptionBox.show()


func _TryBuy():
    for key in StateMachine.upgradeUIInfo.keys():
        var item = StateMachine.upgradeUIInfo[key]
        
        if item["Active"] and item["State"] == "Unlocked":
            if item["Price"] > StateMachine.cancerPoints:
                return
            
            item["State"] = "Bought"
            StateMachine.upgradeHandler.TryUpgrade(key)
            StateMachine.cancerPoints -= item["Price"]
            
            _BoughtUpgradeTexture(key)
            return


func _BoughtUpgradeTexture(buttonname: String):
    var buttonNode = get_node("Background/" + str(buttonname))
    buttonNode.set_texture_normal(load("res://sprites/upgradetree related sprites/bought/" + buttonname + ".png"))
    _UpdateBuyButton(buttonname)


func _UpdateBorderRingPos(button):
    for item in StateMachine.upgradeUIInfo.values():
        item["Active"] = false
    StateMachine.upgradeUIInfo[button]["Active"] = true
    
    borderRing.global_position = get_node("Background/" + str(button)).global_position


func _UpdateBuyButton(button):
    # Hide buy button if an upgrade is already bought
    if not StateMachine.upgradeUIInfo[button]["State"] == "Unlocked":
        buyButton.visible = false
    else:
        buyButton.visible = true
