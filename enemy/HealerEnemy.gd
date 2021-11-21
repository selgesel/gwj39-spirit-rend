extends BaseEnemy

export(float) var cast_cooldown: float = 5
export(float) var heal_threshold: float = .8

onready var _spellcasting: Spellcasting = $Spellcasting

var _is_following: bool = false
var _target: Spatial

var _tracked_allies = {}
var _cooldown: float = 0
var _ally_to_heal

func _physics_process(delta):
    if _is_following:
        movement.navigate_towards(_target.global_transform.origin)
    else:
        movement.set_movement_vector(Vector3.ZERO)

    _cooldown = max(_cooldown - delta, 0)
    if _cooldown <= 0:
        var ally = _find_ally_to_heal()
        if ally:
            _anim.travel("cast")
            _ally_to_heal = ally

    if _target && global_transform.origin.distance_to(_target.global_transform.origin) <= attack_distance:
        _anim.travel("attack")

func _on_sense_detected(target, sense):
    if sense == "ally-detector":
        var key := str(target)
        _tracked_allies[key] = target
        target.connect("tree_exited", self, "_on_ally_died", [key])
    #_is_following = true
    #_target = target

func _on_ally_died(key):
    _tracked_allies.erase(key)

func _find_ally_to_heal():
    var result = null
    var most_health := 9999
    for ally in _tracked_allies.values():
        var health = ally.get("health")
        if health.get_ratio() <= heal_threshold && health.remaining < most_health:
            result = ally
            most_health = health.remaining
    return result

func attack():
    pass

func apply_heal():
    if _ally_to_heal:
        _spellcasting.cast("heal", _ally_to_heal, collision_layer)
        _cooldown = cast_cooldown
