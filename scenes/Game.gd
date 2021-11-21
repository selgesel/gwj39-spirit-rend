extends Spatial

signal loading()
signal loaded()

class_name Game

export(float) var inversion_animate_speed: float = 3
export(float) var min_duration: float = 8
export(float) var max_duration: float = 120

onready var _hud: Control = $HUDLayer/HUD
onready var _inversion_post_process_layer: Control = $HUDLayer/InversionPost
onready var _inversion_shader_mat: ShaderMaterial = _inversion_post_process_layer.material

var remaining: float = 10

var _inversion_alpha: float = 0
onready var _loader: AsyncLoader = $AsyncLoader

var _current_level_id: int = -1
var _current_level: BaseLevel = null
var _is_loading: bool = true

func _process(delta):
    if !_current_level:
        return

    remaining = max(remaining - delta, 0)
    if remaining == 0:
        Globals.invert()
        remaining = 20

    if Globals.is_inverted:
        _inversion_alpha = lerp(_inversion_alpha, 0.2, inversion_animate_speed * delta)
        _inversion_shader_mat.set_shader_param("alpha", _inversion_alpha)
    else:
        _inversion_alpha = lerp(_inversion_alpha, 0, inversion_animate_speed * delta)
        _inversion_shader_mat.set_shader_param("alpha", _inversion_alpha)

func _on_level_load_finished(outcome, args, level_id, loadable):
    match [outcome, args]:
        ["loaded", var Scene]:
            var level: BaseLevel = Scene.instance()
            add_child(level)
            _current_level = level
            _current_level_id = level_id
            emit_signal("loaded")
            level.connect("player_died", self, "_on_player_died")
            level.connect("enemy_died", self, "_on_enemy_died")

        ["failed", var error]:
            print("Load failed %s" % [error])
            #emit_signal("loading_failed", loadable, error)

        ["cancelled", _]:
            print("Load cancelled")

    loadable.queue_free()

func _on_all_goals_reached():
    var player: PhysicsBody = get_tree().get_nodes_in_group("player")[0]
    player.set_physics_process(false)

func _on_player_died(player):
    get_parent().finish_game(false)

func _on_enemy_died(enemy):
    if enemy && enemy.is_in_group("boss"):
        get_parent().finish_game(true)

func unload_level():
    if _current_level:
        _current_level.queue_free()
        _current_level = null
    remaining = 10
    Globals.set_inverted(false)

func load_level(level_id):
    unload_level()

    var level_scene_path = LevelManager.get_level_path(level_id)
    if !level_scene_path:
        return

    emit_signal("loading")
    var loadable: AsyncLoad = _loader.load_resource(level_scene_path)
    loadable.connect("finished", self, "_on_level_load_finished", [level_id, loadable], CONNECT_ONESHOT)

func get_current_level_id() -> int:
    return _current_level_id if _current_level_id >= 0 else -1

func get_formatted_time():
    var minutes = floor(remaining / 60.0)
    var seconds = fmod(remaining, 60)
    return "%02d:%02d" % [minutes, seconds]
