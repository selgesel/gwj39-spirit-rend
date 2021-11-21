extends Node

class_name Root

const STATE_INIT := 0
const STATE_NOT_IN_GAME := 1
const STATE_LOADING := 2
const STATE_IN_GAME_PLAYING := 3
const STATE_IN_GAME_PAUSED := 4
const STATE_GAME_FINISHED := 5

onready var _screen_title: Control = $CanvasLayer/TitleScreen
onready var _screen_pause: Control = $CanvasLayer/PauseScreen
onready var _screen_loading: Control = $CanvasLayer/LoadingScreen
onready var _screen_win: Control = $CanvasLayer/WinScreen
onready var _screen_lose: Control = $CanvasLayer/LoseScreen
onready var _loader: AsyncLoader = $AsyncLoader
onready var _game: Game = $Game

var _state := STATE_INIT

func _ready():
    _state = STATE_NOT_IN_GAME
    _game.connect("loading", self, "_on_game_loading")
    _game.connect("loaded", self, "_on_game_loaded")

func _on_game_loading():
    _screen_loading.visible = true
    _state = STATE_LOADING

func _on_game_loaded():
    _screen_loading.visible = false
    _state = STATE_IN_GAME_PLAYING

    if !Globals.is_touchscreen():
        Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
    if event is InputEventKey && event.is_action_pressed("ui_cancel"):
        if _state == STATE_IN_GAME_PLAYING:
            pause_game()

func pause_game():
    if _state != STATE_IN_GAME_PLAYING:
        return

    if !Globals.is_touchscreen():
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

    _screen_pause.visible = true
    _state = STATE_IN_GAME_PAUSED
    get_tree().paused = true

func resume_game():
    if _state != STATE_IN_GAME_PAUSED:
        return

    if !Globals.is_touchscreen():
        Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

    _screen_pause.visible = false
    _state = STATE_IN_GAME_PLAYING
    get_tree().paused = false

func finish_game(has_won: bool):
    if _state != STATE_IN_GAME_PLAYING:
        return

    if !Globals.is_touchscreen():
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

    _state = STATE_GAME_FINISHED
    get_tree().paused = true
    if has_won:
        _screen_win.visible = true
    else:
        _screen_lose.visible = true

func start_new_game(level_id: int = 0):
    if _state == STATE_INIT:
        return

    _game.unload_level()
    _game.visible = false
    _screen_pause.visible = false
    _screen_title.visible = false
    _screen_win.visible = false
    _screen_lose.visible = false
    _screen_loading.visible = true

    _state = STATE_LOADING
    get_tree().paused = false
    _game.load_level(level_id)
    _game.visible = true

func quit_game():
    if _state == STATE_NOT_IN_GAME:
        return

    _game.unload_level()
    _game.visible = false
    _screen_pause.visible = false
    _screen_win.visible = false
    _screen_lose.visible = false
    _screen_title.visible = true
    _state = STATE_NOT_IN_GAME

func terminate():
    get_tree().quit(0)
