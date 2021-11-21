extends Control

onready var _health_bar = $VBoxContainer/HealthBarWrapper
onready var _mana_bar = $VBoxContainer/ManaBarWrapper
onready var _time_label: Label = $TimeLabel

func _process(delta):
    var tree := get_tree()

    for player in tree.get_nodes_in_group("player"):
        _health_bar.update(player.health.remaining, player.health.total)
        _mana_bar.update(player.mana.remaining, player.mana.total)

    for game in tree.get_nodes_in_group("game"):
        _time_label.text = game.get_formatted_time()
