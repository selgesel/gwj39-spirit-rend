extends Node

export(float) var animate_speed: float = 4
export(float) var animate_delay: float = .4

onready var _label: Label = $Label
onready var _bar_over: Control = $BarOver
onready var _bar_under: Control = $BarUnder

var _remaining: float = 0
var _total: float = 0
var _ratio: float = 1.0

func update(remaining, total):
    if _remaining == remaining && _total == total:
        return

    _remaining = remaining
    _total = total

    _ratio = 0 if total == 0 else float(remaining) / float(total)
    _bar_over.value = _ratio * 100.0
    _label.text = "%d/%d" % [round(remaining), round(total)]

func _process(delta):
    _bar_under.value = lerp(_bar_under.value, _ratio * 100.0, delta * animate_speed)
