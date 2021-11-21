extends Node

class_name Sustenance

signal changed(amount, remaining, total)
signal depleted()

export(float) var total: float = 200
export(float) var upper_limit: float = 200
export(float) var lower_limit: float = 0
export(bool) var enabled: bool = true

onready var remaining: float = total

var _changes := []

func _recalculate():
    var remaining := total
    for change in _changes:
        remaining += change.amount
    remaining = clamp(remaining, lower_limit, upper_limit)
    self.remaining = remaining
    return remaining

func _change(delta):
    var actual_amount = delta * Globals.get_inversion_factor()
    _changes.append({"amount": actual_amount})
    var remaining = _recalculate()
    emit_signal("changed", actual_amount, remaining, total)
    if remaining <= 0:
        emit_signal("depleted")

func decrease(amount):
    _change(-amount)

func increase(amount):
    _change(amount)

func get_ratio():
    return 0 if total == 0 else remaining / total
