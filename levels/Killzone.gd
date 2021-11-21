extends Area

func _physics_process(delta):
    for body in get_overlapping_bodies():
        if body.has_method("hurt"):
            body.hurt(1000000000)
        else:
            body.queue_free()
