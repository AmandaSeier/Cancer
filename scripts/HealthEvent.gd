extends ColorRect
class_name HealthEvent

@onready var HealthEventTitle: Label = get_node("HealthEventTitle")

var colorValBox: float = 31. / 255.
var colorValText: float = 1

var fadeInTimer: Timer
var fadeOutTimer: Timer
var fadeOutCount: float = 100
var fadeInCount: float = 0
const fadeBy: float = 5


func _ready() -> void:
    fadeInTimer = Timer.new()
    fadeOutTimer = Timer.new()
    fadeInTimer.wait_time = 0.01
    fadeOutTimer.wait_time = 0.01
    add_child(fadeInTimer)
    add_child(fadeOutTimer)
    fadeInTimer.timeout.connect(_fadeIn)
    fadeOutTimer.timeout.connect(_fadeOut)


func NewMessage(msg: String, time: float) -> void:
    HealthEventTitle.text = msg

    var timer := Timer.new()
    timer.wait_time = time
    timer.one_shot = true
    timer.timeout.connect(_fadeOut)
    timer.timeout.connect(func(): remove_child(timer))
    add_child(timer)
    timer.start()

    _fadeIn()



func _fadeOut() -> void:
    fadeOutTimer.start()
    if fadeOutCount > 0:
        self.color = Color(colorValBox, colorValBox, colorValBox, fadeOutCount / 100)
        HealthEventTitle.set("theme_override_colors/font_color", Color(colorValText, colorValText, colorValText, fadeOutCount / 100))
    
    fadeOutCount -= fadeBy

    if fadeOutCount == 0:
        self.color = Color(colorValBox, colorValBox, colorValBox, 0)
        HealthEventTitle.set("theme_override_colors/font_color", Color(colorValText, colorValText, colorValText, 0))
        _stopAndReset(false, true)
    

func _fadeIn() -> void:
    fadeInTimer.start()
    if fadeInCount <= 100:
        self.color = Color(colorValBox, colorValBox, colorValBox, fadeInCount / 100)
        HealthEventTitle.set("theme_override_colors/font_color", Color(colorValText, colorValText, colorValText, fadeInCount / 100))
    
    fadeInCount += fadeBy
    
    if fadeInCount == 100:
        self.color = Color(colorValBox, colorValBox, colorValBox, 1)
        HealthEventTitle.set("theme_override_colors/font_color", Color(colorValText, colorValText, colorValText, 1))
        _stopAndReset(true, false)


func _stopAndReset(fadeIn: bool, fadeOut: bool) -> void:
    if fadeIn:
        fadeInTimer.stop()
        fadeInCount = 0
    elif fadeOut:    
        fadeOutTimer.stop()
        fadeOutCount = 100


func _on_button_pressed() -> void:
    _fadeOut()


func _on_button_2_pressed() -> void:
    _fadeIn()
