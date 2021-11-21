extends Control

onready var _root: Root = get_tree().get_nodes_in_group("root")[0]
onready var _bg: Panel = $Background

func _on_BtnExit_pressed():
    _root.terminate()

func _on_BtnNewGame_pressed():
    _root.start_new_game()
