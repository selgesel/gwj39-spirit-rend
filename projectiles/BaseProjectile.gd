extends KinematicBody

class_name BaseProjectile

export(float) var gravity: float = 9.8
export(float) var damage: float = 10

var _velocity: Vector3 = Vector3.ZERO

func _ready():
    set_as_toplevel(true)

func _physics_process(delta):
    _velocity += Vector3.DOWN * gravity * delta
    var collision := move_and_collide(_velocity * delta)
    if collision:
        if collision.collider.has_method("hurt"):
            collision.collider.hurt(damage)
        set_physics_process(false)
        queue_free()

func launch(velocity: Vector3):
    _velocity = velocity
    look_at(global_transform.origin + velocity, Vector3.UP)
