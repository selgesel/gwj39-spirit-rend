extends Node

signal inverted()

var is_inverted: bool = false
var _is_touchscreen: bool = false

func _ready():
    var os_name := OS.get_name()
    if os_name == "Android" || os_name == "iOS":
        _is_touchscreen = true

func invert():
    is_inverted = !is_inverted
    emit_signal("inverted")

func set_inverted(inverted):
    is_inverted = inverted

func get_inversion_factor() -> int:
    return -1 if is_inverted else 1

func is_touchscreen():
    return _is_touchscreen
