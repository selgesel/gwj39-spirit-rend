extends Node

class_name LevelManager

const DebugLevelScene = "res://levels/DebugLevel.tscn"
const MainLevelScene = "res://levels/MainLevel.tscn"

const LevelScenes = [
    MainLevelScene
]

static func get_level_path(level_id: int):
    if level_id < 0 || level_id >= LevelScenes.size():
        return null
    return LevelScenes[level_id]

static func has_next(level_id: int):
    return (level_id + 1) >= 0 && (level_id + 1) < LevelScenes.size()
