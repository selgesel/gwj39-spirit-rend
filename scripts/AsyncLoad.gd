extends Node

class_name AsyncLoad

signal started()
signal progressed(progress)
signal finished(outcome, args)

var path: String
var is_started = false
var is_cancelling = false
var progress: float = 0

func load_fully():
    if is_started:
        return
    is_started = true
    call_deferred("_do_load")

func _do_load():
    var loader: ResourceInteractiveLoader = ResourceLoader.load_interactive(path)
    emit_signal("started")

    while true:
        if is_cancelling:
            emit_signal("finished", "cancelled", null)
            loader.free()
            break

        var err = loader.poll()
        if err == ERR_FILE_EOF:
            emit_signal("finished", "loaded", loader.get_resource())
            break
        elif err == OK:
            var progress = loader.get_stage() / max(1, loader.get_stage_count())
            self.progress = progress
            emit_signal("progressed", progress)
        else:
            emit_signal("finished", "failed", err)
            #loader.free() # is this safe?
            break
