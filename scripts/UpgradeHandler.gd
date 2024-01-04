class_name UpgradeHandler

var _upgrades: Dictionary       # @type: Dict[String, bool]
var _upgradeValues: Dictionary  # @type: Dict[String, Dict[String, float]]


func _init(upgradeValues: Dictionary) -> void:
	assert(upgradeValues != null, "No upgradeValues provided to UpgradeHandler")

	# Copy the upgrade values i.e. what each upgrade contributes to
	_upgradeValues = upgradeValues

	# Copy each upgrade name into the _upgrades dict
	for type in _upgradeValues.values():
		for name in type.keys():
			_upgrades[name] = false

	# base values always apply
	_upgrades["base"] = true


func TryUpgrade(upgradeName: String) -> bool:
	if not _upgrades.has(upgradeName):
		return false

	_upgrades[upgradeName] = true
	return true


func TryDowngrade(upgradeName: String) -> bool:
	if not _upgrades.has(upgradeName):
		return false

	_upgrades[upgradeName] = false
	return true


func IsUpgraded(upgradeName: String) -> bool:
	return _upgrades[upgradeName]


# Returns empty dict if something failed
func GetUpgradeValues() -> Dictionary:
	var outValues: Dictionary = {}  # @type: Dict[String, float]
	for category in _upgradeValues.keys():
		outValues[category] = 0.
		# For each upgrade within the current category 
		for upgrade in _upgradeValues[category].keys():
			outValues[category] += _upgradeValues[category][upgrade] * (_upgrades[upgrade] as float)
	
	return outValues;

