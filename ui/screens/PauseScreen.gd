extends Control

onready var _root: Root = get_tree().get_nodes_in_group("root")[0]

func _on_BtnResume_pressed():
    _root.resume_game()

func _on_BtnQuit_pressed():
    _root.quit_game()
