tool

signal detected(target)

extends Area

class_name SpiderSense

export(String) var sense_name: String = "spider-sense"

var _coll_shape: CollisionShape

func _ready():
    _coll_shape = get_node("CollisionShape")
    self.connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
    emit_signal("detected", body)
