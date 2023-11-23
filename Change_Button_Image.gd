# from https://ask.godotengine.org/81711/how-to-get-
# button-to-change-its-texture-every-time-it-pressed

extends Node

var _texture1 = load("res://number1.png")
var _texture2 = load("res://number2.png")
var _texture_toggle: int = 1

func _on_TextureButton_pressed() -> void:
	if _texture_toggle == 1:
		$TextureButton.texture_pressed = _texture2
		$TextureButton.texture_normal = _texture1
		_texture_toggle = 2
	else:
		$TextureButton.texture_pressed = _texture1
		$TextureButton.texture_normal = _texture2
		_texture_toggle = 1
