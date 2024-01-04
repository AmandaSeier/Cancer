extends Node 


var pointsPrCancerCell: float = 1.

# arbitrary placeholder variables
# ------------
var sizeDifference: int = 100 # difference in colony size between payouts.
# in case of money per payout scaler 
var moneyScale: float = 1.
# ------------

var payoutDelay: int = 10 # 10 days
var daysTillPayout: int = payoutDelay


# Called when the node enters the scene tree for the first time.
func _ready():
	StateMachine.OnNextDay.connect(_CalcCancerPoints)


func _CalcCancerPoints():
	if not daysTillPayout == 1:
		daysTillPayout -= 1
		return
	daysTillPayout = payoutDelay
	
	StateMachine.cancerPoints += pointsPrCancerCell * sizeDifference * moneyScale
	_UpdateCancerPoints()


# call on Upgrade-bought
func _RemoveCancerPoints(upgradePrice):
	StateMachine.cancerPoints -= upgradePrice
	_UpdateCancerPoints()


func _UpdateCancerPoints():
	self.text = "Cancer points: {CP}".format({"CP": StateMachine.cancerPoints})
	
