extends Node

class_name Movement

export(bool) var enabled: bool = true

export(float) var move_speed: float = 6
export(float) var turn_speed: float = 10
export(float) var acceleration: float = 50
export(float) var max_slope_angle: float = 70 setget set_max_slope_angle
export(bool) var lock_rotation: bool = false

export(float) var gravity: float = .98
export(float) var jump_force: float = 16
export(float) var max_terminal_velocity: float = 50
export(int) var max_jumps: int = 0
export(float) var jump_cooldown: float = .2

var nav: Navigation
var target: Spatial

var _move_vec: Vector3 = Vector3.ZERO
var _velocity: Vector3 = Vector3.ZERO
var _floor_normal: Vector3 = Vector3.DOWN
var _y_velocity: float = 0
var _max_slope_angle: float = 0
var _rotation: float = 0
var _jump_count: int = 0
var _jump_cooldown_remaining: float = 0
var _will_jump: bool = false

var _last_path: PoolVector3Array
onready var _cam := get_viewport().get_camera()

func _ready():
    set_max_slope_angle(max_slope_angle)

func _physics_process(delta):
    if !target || !enabled:
        return

    var direction = Vector3(_move_vec.x, 0, _move_vec.z)

    _velocity = _velocity.linear_interpolate(direction * move_speed, acceleration * delta)

    if target.is_on_floor():
        _y_velocity = 0
        _jump_count = 0
        _jump_cooldown_remaining = 0
    else:
        _jump_cooldown_remaining = clamp(_jump_cooldown_remaining - delta, 0, jump_cooldown)
        _y_velocity = clamp(_y_velocity - gravity, -max_terminal_velocity, max_terminal_velocity)

    var jumping := false
    if _will_jump && _can_jump():
        _will_jump = false
        _y_velocity = jump_force
        _jump_count += 1
        _jump_cooldown_remaining = jump_cooldown
        jumping = true

    _velocity.y = _y_velocity

    if jumping:
        _velocity = target.move_and_slide(_velocity, Vector3.UP, true, 4, _max_slope_angle)
    else:
        _velocity = target.move_and_slide_with_snap(_velocity, -_floor_normal, Vector3.UP, true, 4, _max_slope_angle)

    if target.is_on_floor():
        _floor_normal = target.get_floor_normal()

func _can_jump():
    return _jump_count < max_jumps && _jump_cooldown_remaining <= 0

func jump():
    if _can_jump():
        _will_jump = true

func get_velocity() -> Vector3:
    return _velocity

func set_movement_vector(move_vec: Vector3):
    _move_vec = move_vec

func set_max_slope_angle(angle):
    _max_slope_angle = deg2rad(angle)
    max_slope_angle = angle

func navigate_towards(position: Vector3):
    if !nav:
        return

    var origin := target.global_transform.origin
    if origin.distance_to(position) <= .1:
        return Vector3.ZERO
    var path := nav.get_simple_path(origin, position)
    var target_point: Vector3 = origin
    if path.size() > 1:
        target_point = path[1]
    else:
        target_point = nav.get_closest_point(position)
        target_point.y = origin.y
    _last_path = path
    var dir := target_point - origin
    dir.y = 0
    if dir.length() <= .001:
        _move_vec = Vector3.ZERO
    else:
        _move_vec = dir.normalized()

func stop():
    set_movement_vector(Vector3.ZERO)

func face_movement_direction(node: Spatial, delta: float):
    if lock_rotation:
        return

    _rotation = lerp_angle(_rotation, atan2(_move_vec.z, _move_vec.x), turn_speed * delta)
    node.rotation.y = _rotation

func face_target(node: Spatial, target: Spatial, delta: float):
    if lock_rotation:
        return
    
    var look_vec := target.global_transform.origin - node.global_transform.origin
    var angle := atan2(-look_vec.x, -look_vec.z)
    _rotation = lerp_angle(_rotation, angle, turn_speed * delta)
    node.rotation.y = _rotation
