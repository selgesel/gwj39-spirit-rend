extends BaseEnemy

onready var _weapon_hitbox: Area = $Skin/WeaponHitbox
onready var _smp = $StateMachinePlayer
onready var _confidence_timer: Timer = $ConfidenceTimer
onready var _vision: Vision = $Senses/Vision

var _is_following: bool = false
var _target: Spatial

func _setup():
    _confidence_timer.connect("timeout", self, "_on_confidence_timer_tick")
    _smp.connect("transited", self, "_on_smp_transited")
    _smp.set_trigger("ready")

func _physics_process(delta):
    if !_target:
        return

    var distance := global_transform.origin.distance_to(_target.global_transform.origin)
    _smp.set_param("is_enemy_in_range", distance <= attack_distance)
    _smp.set_param("is_enemy_in_los", _vision.is_detected())

    match _smp.current:
        "Alerted":
            movement.stop()
            movement.face_target(self, _target, delta)
        "Chasing":
            if _vision.is_detected():
                movement.face_target(self, _target, delta)
            else:
                movement.face_movement_direction(self, delta)
            movement.navigate_towards(_target.global_transform.origin)
        "Attacking":
            movement.stop()
            movement.face_target(self, _target, delta)
            _anim.travel("attack")

func _on_sense_detected(target, sense):
    if sense == "spider-sense":
        _smp.set_trigger("enemy_sensed")
        _vision.target = target
    else:
        _target = target

func attack():
    for target in _weapon_hitbox.get_overlapping_bodies():
        if target.has_method("hurt"):
            target.hurt(damage)

func _on_confidence_timer_tick():
    _smp.set_param("is_confident", true)

func _on_smp_transited(from, to):
    match to:
        "Alerted":
            _confidence_timer.start()
