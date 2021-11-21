extends Control

onready var _root: Root = get_tree().get_nodes_in_group("root")[0]

func _on_BtnQuit_pressed():
    _root.quit_game()

func _on_BtnRestart_pressed():
    _root.start_new_game()
