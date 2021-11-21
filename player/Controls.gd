extends Node

signal action()

class_name Controls

const KnownActions = ["jump", "attack", "skill"]

export(float) var min_pitch: float = -90
export(float) var max_pitch: float = 75
export(float) var zoom_step: float = .05
export(float) var sensitivity: float = 0.1

onready var _mobile_controls = $MobileControls

var _move_vec: Vector2 = Vector2.ZERO
var _cam_rot: Vector2 = Vector2.ZERO
var _zoom_scale: float = 0

var _active_actions := {}

func _ready():
    if Globals.is_touchscreen():
        _mobile_controls.visible = true

func _process(delta):
    if !Globals.is_touchscreen():
        var dx := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
        var dy := Input.get_action_strength("move_forward") - Input.get_action_strength("move_backwards")

        _move_vec = Vector2(dx, -dy).normalized()
    else:
        _move_vec = _mobile_controls.get_movement_vector()
        _cam_rot = _mobile_controls.get_camera_rotation()
        _zoom_scale = _mobile_controls.get_zoom_scale()

    for action in KnownActions:
        if Input.is_action_just_pressed(action):
            emit_signal("action", action)
            _active_actions[action] = true
        elif Input.is_action_just_released(action):
            _active_actions.erase(action)

func _input(event):
    if !Globals.is_touchscreen() && event is InputEventMouseMotion:
        _cam_rot.x -= event.relative.x * sensitivity
        _cam_rot.y -= event.relative.y * sensitivity
        _cam_rot.y = clamp(_cam_rot.y, min_pitch, max_pitch)

    if Input.is_action_just_pressed("zoom_in"):
        _zoom_scale = clamp(_zoom_scale - zoom_step, 0, 1)
    if Input.is_action_just_pressed("zoom_out"):
        _zoom_scale = clamp(_zoom_scale + zoom_step, 0, 1)

func get_movement_vector() -> Vector2:
    return _move_vec

func get_camera_rotation():
    return _cam_rot

func get_zoom_scale():
    return _zoom_scale

func set_zoom_scale(zoom_scale):
    _zoom_scale = zoom_scale
    _mobile_controls.set_zoom_scale(zoom_scale)

func is_action_pressed(action):
    return _active_actions.has(action)
