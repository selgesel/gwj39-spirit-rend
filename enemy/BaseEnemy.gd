extends KinematicBody

signal died()

class_name BaseEnemy

export(String) var navigation_key: String = "navigation"
export(float) var damage: float = 8
export(float) var attack_distance: float = 2

onready var movement: Movement = $Movement
onready var health: Sustenance = $Health

onready var _anim: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")
onready var _skin: Spatial = $Skin
onready var _senses: Spatial = $Senses

func _ready():
    movement.target = self
    health.connect("depleted", self, "_on_health_depleted")

    var navs := get_tree().get_nodes_in_group(navigation_key)
    if !navs.empty():
        movement.nav = navs[0]

    for sense in _senses.get_children():
        if sense.get("sense_name"):
            sense.connect("detected", self, "_on_sense_detected", [sense.sense_name])

    call_deferred("_setup")

func _on_health_depleted():
    _anim.travel("die")
    set_physics_process(false)
    emit_signal("died")

func _on_sense_detected(target, sense):
    pass

func _setup():
    pass

func hurt(amount):
    health.decrease(amount)

func heal(amount):
    health.increase(amount)
