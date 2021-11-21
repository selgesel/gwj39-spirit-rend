extends Control

export(float) var visibility_distance: float = 30

onready var _health_bar = $VBoxContainer/HealthBar
onready var _enemy = get_parent()

var _player: Player

func _physics_process(delta):
    var player = _get_player()
    if !player:
        visible = false
        return

    var world_pos: Vector3 = get_parent().global_transform.origin
    var player_pos: Vector3 = player.global_transform.origin

    var screen_pos := get_viewport().get_camera().unproject_position(world_pos)
    set_global_position(screen_pos)

    var look_vec := player_pos - world_pos
    var look_angle := atan2(look_vec.z, look_vec.x)
    var cam_forward: Vector3 = player.get_camera_forward()
    var cam_angle := atan2(cam_forward.z, cam_forward.x)

    visible = look_vec.length() <= visibility_distance && abs(cam_angle - look_angle) <= PI / 2

func _process(delta):
    _health_bar.update(owner.health.remaining, owner.health.total)

func _get_player():
    if !_player:
        var nodes = get_tree().get_nodes_in_group("player")
        if !nodes.empty():
            _player = nodes[0]

    return _player
