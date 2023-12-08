extends Node 


var cancerPoints: int = 0

# arbitrary placeholder variables
# ------------
var sizeDifference: int = 100
# in case of money per payout scaler 
var moneyScale: float = 1.
# ------------

var payoutDelay: int = 10 # 10 days
var daysTillPayout: int = payoutDelay


# Called when the node enters the scene tree for the first time.
func _ready():
	StateMachine.OnNextDay.connect(_CalcCancerPoints)

func _stuff():
	print("Amount of cancer colonies: ", StateMachine.colonies)


func _CalcCancerPoints():
	if not daysTillPayout == 0:
		daysTillPayout -= 1
		return
	daysTillPayout = payoutDelay
	
	cancerPoints += sizeDifference * moneyScale
	self.text = "Cancer points: {CP}".format({"CP": cancerPoints})

func _AddCancerPoints():
	pass

# call on Upgrade-bought
func _RemoveCancerPoints():
	pass
