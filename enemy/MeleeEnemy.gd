extends BaseEnemy

onready var _weapon_hitbox: Area = $Skin/WeaponHitbox

var _is_following: bool = false
var _target: Spatial

func _physics_process(delta):
    if _is_following:
        movement.navigate_towards(_target.global_transform.origin)
    else:
        movement.set_movement_vector(Vector3.ZERO)

    if _target && global_transform.origin.distance_to(_target.global_transform.origin) <= attack_distance:
        _anim.travel("attack")

func _on_sense_detected(target, sense):
    _is_following = true
    _target = target

func attack():
    for target in _weapon_hitbox.get_overlapping_bodies():
        if target.has_method("hurt"):
            target.hurt(damage)
