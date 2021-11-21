tool

extends Spatial

class_name ControllableCamera

export(float) var rotate_speed: float = 10
export(float) var zoom_speed: float = 10
export(float) var min_distance: float = 3
export(float) var max_distance: float = 10
export(float) var distance: float = 6 setget set_distance

onready var _gimbal_h: Spatial = $GimbalH
onready var _gimbal_v: Spatial = $GimbalH/GimbalV
onready var _camera: ClippedCamera = $GimbalH/GimbalV/ClippedCamera

var _controls: Controls

var _rot_h: float = 0
var _rot_v: float = 0
var _distance: float = 0

func _ready():
    for controls in get_tree().get_nodes_in_group("controls"):
        _controls = controls
    #yield(get_parent(), "ready")
    set_distance(distance)

func _process(delta):
    if !_controls || Engine.editor_hint:
        return

    var cam_rot: Vector2 = _controls.get_camera_rotation()
    _rot_h = cam_rot.x
    _rot_v = cam_rot.y

    _distance = _controls.get_zoom_scale() * (max_distance - min_distance) + min_distance

func _physics_process(delta):
    if _gimbal_h:
        _gimbal_h.rotation_degrees.y = lerp(_gimbal_h.rotation_degrees.y, _rot_h, rotate_speed * delta)

    if _gimbal_v:
        _gimbal_v.rotation_degrees.x = lerp(_gimbal_v.rotation_degrees.x, _rot_v, rotate_speed * delta)

    #_camera.transform.origin.z = lerp(_camera.transform.origin.z, _distance, zoom_speed * delta)

func set_distance(new_distance: float):
    if _camera:
        _camera.transform.origin.z = distance
    distance = new_distance
    #var zoom_scale := (new_distance - min_distance) / (max_distance - min_distance)
    #_controls.set_zoom_scale(zoom_scale)

func get_forward():
    return _camera.global_transform.basis.z
