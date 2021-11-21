tool

extends BaseSpell

export(float) var power: float = 10
export(float) var tick_interval: float = .3 setget set_tick_interval

onready var _timer: Timer = $Timer

func _ready():
    if _timer:
        _timer.connect("timeout", self, "_on_timer_tick")
    set_tick_interval(tick_interval)

func _on_timer_tick():
    $Seal.emitting = true
    for body in get_overlapping_bodies():
        if body.has_method("heal"):
            body.heal(power)

func cast(target: Spatial):
    if !target:
        return

    var cast_origin := target.global_transform.origin + Vector3.UP
    var cast_target := target.global_transform.origin + Vector3.DOWN * 10
    var ray_info := get_world().direct_space_state.intersect_ray(cast_origin, cast_target, [target])
    if !ray_info.empty():
        global_transform.origin = ray_info.position + Vector3.UP * .01
    else:
        global_transform.origin = target.global_transform.origin + Vector3.UP * .01
    _anim.travel("cast")

func set_tick_interval(interval):
    if _timer:
        _timer.start()
        _timer.wait_time = interval
    tick_interval = interval
