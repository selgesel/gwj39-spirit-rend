extends BaseEnemy

export(float) var accuracy: float = 1
export(float) var prediction_accuracy: float = 1
export(float) var projectile_speed: float = 16
export(float) var safe_distance: float = 32
export(float) var cooldown: float = 2
export(float) var projectile_gravity: float = 9.8
export(PackedScene) var projectile_scene
export(int, LAYERS_3D_PHYSICS) var projectile_collision_mask: int = 2

onready var _launch_origin: Position3D = $ArrowLaunchOrigin

var _cooldown: float = 0
var _is_following: bool = false
var _target: Spatial

func _physics_process(delta):
    if !_target:
        return

    var is_in_range := false

    _cooldown = max(_cooldown - delta, 0)

    if _is_following && global_transform.origin.distance_to(_target.global_transform.origin) >= safe_distance:
        movement.navigate_towards(_target.global_transform.origin)
    else:
        is_in_range = true
        movement.set_movement_vector(Vector3.ZERO)

    if is_in_range && _cooldown <= 0:
        _cooldown = cooldown
        _anim.travel("shoot")

func _on_sense_detected(target, sense):
    _is_following = true
    _target = target

func get_shoot_dir() -> Vector3:
    #var vt: Vector3 = _target.movement._velocity
    # TODO impl accurate shots
    return (_target.global_transform.origin - _launch_origin.global_transform.origin).normalized()

func shoot():
    if !_target:
        return

    var arrow: BaseProjectile = projectile_scene.instance()
    arrow.collision_mask = projectile_collision_mask
    add_child(arrow)
    arrow.global_transform.origin = _launch_origin.global_transform.origin
    arrow.gravity = projectile_gravity
    var launch_vec := get_shoot_dir() * projectile_speed
    launch_vec.y = 0
    arrow.call_deferred("launch", launch_vec)
