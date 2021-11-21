extends Node

signal started(path)

class_name AsyncLoader

const AsyncLoadScene: PackedScene = preload("res://scripts/AsyncLoad.tscn")

var queue = []
var pending = {}
var is_tearing_down = false

var thread: Thread
var semaphore: Semaphore
var mx_exit_flag: Mutex
var mx_queue: Mutex
var mx_pending: Mutex

func _init():
    thread = Thread.new()
    mx_exit_flag = Mutex.new()
    mx_queue = Mutex.new()
    mx_pending = Mutex.new()
    semaphore = Semaphore.new()
    
    thread.start(self, "_thread_loop", OS.get_ticks_msec())

func load_resource(path: String) -> AsyncLoad:
    var loader: AsyncLoad = null
    mx_pending.lock()
    if pending.has(path):
        loader = pending[path]
    else:
        loader = AsyncLoadScene.instance()
        loader.path = path
        pending[path] = loader
        mx_queue.lock()
        queue.push_back(path)
        mx_queue.unlock()
    mx_pending.unlock()
    call_deferred("_go")
    return loader

func _go():
    semaphore.post()

func _thread_process():
    semaphore.wait()

    while true:
        var path
        mx_queue.lock()
        if queue.size() < 1:
            mx_queue.unlock()
            return
        path = queue.pop_front()
        mx_queue.unlock()

        var loader: AsyncLoad
        mx_pending.lock()
        loader = pending[path]
        mx_pending.unlock()

        loader.load_fully()

        mx_pending.lock()
        pending.erase(path)
        mx_pending.unlock()

func _thread_loop(_started):
    while true:
        var should_exit = false
        mx_exit_flag.lock()
        should_exit = is_tearing_down
        mx_exit_flag.unlock()

        if should_exit:
            return
        else:
            _thread_process()

func _exit_tree():
    mx_exit_flag.lock()
    is_tearing_down = true
    mx_exit_flag.unlock()


    mx_queue.lock()
    pending.clear()
    mx_queue.unlock()

    mx_pending.lock()
    for key in pending.keys():
        pending[key].cancel()
    pending = {}
    mx_pending.unlock()

    semaphore.post()

    thread.wait_to_finish()
