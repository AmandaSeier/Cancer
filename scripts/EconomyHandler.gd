extends Node 


const pointsPrCancerCell: float = 0.0001

const payoutDelay: int = 30 # days
var daysTillPayout: int = payoutDelay


# Called when the node enters the scene tree for the first time.
func _ready():
    StateMachine.OnNextDay.connect(_CalcCancerPoints)


func _CalcCancerPoints():
    if not daysTillPayout == 1:
        daysTillPayout -= 1
        return
    daysTillPayout = payoutDelay
    
    StateMachine.cancerPoints += round(pointsPrCancerCell * StateMachine.GetTotalGrowth())
    _UpdateCancerPoints()


# call on Upgrade-bought
func _RemoveCancerPoints(upgradePrice):
    StateMachine.cancerPoints -= upgradePrice
    _UpdateCancerPoints()


func _UpdateCancerPoints():
    self.text = "Cancer points: {CP}".format({"CP": StateMachine.cancerPoints})
    
