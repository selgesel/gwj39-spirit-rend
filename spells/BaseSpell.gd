extends Area

class_name BaseSpell

onready var _anim: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")

func _ready():
    set_as_toplevel(true)

func apply():
    pass

func cast(target: Spatial):
    pass
