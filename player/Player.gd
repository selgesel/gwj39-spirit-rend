extends KinematicBody

signal died()

class_name Player

export(float) var cam_follow_speed: float = 8
export(float) var turn_speed: float = 10
export(int, LAYERS_3D_PHYSICS) var heal_mask: int = 6
export(float) var damage: float = 40

onready var health: Sustenance = $Health
onready var mana: Sustenance = $Mana

onready var _movement: Movement = $Movement
onready var _controls: Controls = $Controls
onready var _camera: ControllableCamera = $CamRoot/ControllableCamera
onready var _skin: Spatial = $Skin
onready var _weapon_hitbox: Area = $Skin/WeaponHitbox
onready var _anim: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")
onready var _spellcasting: Spellcasting = $Spellcasting

var _move_rot: float = 0
var _rotation: float = 0
var _is_casting: bool = false
var _casting_finished: bool = false
var current_spell_name: String = "heal"

func _ready():
    _movement.target = self
    _controls.connect("action", self, "_on_controls_action")
    health.connect("depleted", self, "_on_health_depleted")

func _on_controls_action(action):
    match action:
        "jump": _movement.jump()
        "attack": _anim.travel("attack")
        "skill": _anim.travel("cast_spell")

func _physics_process(delta):
    var move_vec := _controls.get_movement_vector()
    var direction := Vector3(move_vec.x, 0, move_vec.y)

    _move_rot = lerp(_move_rot, deg2rad(_camera._rot_h), cam_follow_speed * delta)
    direction = direction.rotated(Vector3.UP, _move_rot)
    _skin.rotation.y = _move_rot

    _movement.set_movement_vector(direction)

    #if !direction.is_equal_approx(Vector3.ZERO):
        #_rotation = lerp_angle(_rotation, atan2(-direction.x, -direction.z), turn_speed * delta)
        #_skin.rotation.y = _rotation

func get_velocity() -> Vector3:
    return _movement.get_velocity()

func attack():
    for enemy in _weapon_hitbox.get_overlapping_bodies():
        if enemy.has_method("hurt"):
            enemy.hurt(damage)

func hurt(amount):
    health.decrease(amount)

func start_casting():
    _casting_finished = false

func cast_spell():
    _spellcasting.cast(current_spell_name, self, heal_mask)

func finish_casting():
    _casting_finished = true
    if _controls.is_action_pressed("skill"):
        _anim.travel("cast_spell")

func heal(amount):
    health.increase(amount)

func get_camera_forward() -> Vector3:
    return _camera.get_forward()

func _on_health_depleted():
    set_physics_process(false)
    emit_signal("died")

