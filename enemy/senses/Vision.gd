extends Spatial

signal detected(target)
signal lost()

class_name Vision

export(String) var sense_name: String = "vision"
export(float) var vision_cone_radius: float = 160 setget set_vision_cone_radius
export(int, LAYERS_3D_PHYSICS) var occlusion_mask: int = 1

var target: Spatial

var _radius: float = 0
var _was_detected: bool = false

func _ready():
    set_vision_cone_radius(vision_cone_radius)

func _physics_process(delta):
    if !target:
        _set_not_detected()
        return

    var target_pos := target.global_transform.origin if !target.has_method("get_eye_level") else target.get_eye_level()
    var state := get_world().direct_space_state
    var look_vec := global_transform.origin - target_pos
    var angle := atan2(look_vec.z, look_vec.x)
    if abs(angle) <= _radius && _has_los(target_pos):
        _set_detected()
    else:
        _set_not_detected()

func _has_los(target_pos):
    var collision = get_world().direct_space_state.intersect_ray(global_transform.origin, target_pos, [self, target], occlusion_mask)
    return !collision

func _set_not_detected():
    if !_was_detected:
        return

    emit_signal("lost")
    _was_detected = false

func _set_detected():
    if _was_detected:
        return

    emit_signal("detected", target)
    _was_detected = true

func is_detected():
    return _was_detected

func set_vision_cone_radius(angles):
    _radius = deg2rad(angles)
    vision_cone_radius = angles
