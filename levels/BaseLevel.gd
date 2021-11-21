extends Node

signal player_died(player)
signal enemy_died(enemy)

class_name BaseLevel

onready var _player: Player = $Player

func _ready():
    _player.connect("died", self, "_on_player_died")
    for enemy in get_tree().get_nodes_in_group("enemy"):
        enemy.connect("died", self, "_on_enemy_died", [enemy])

func _on_player_died():
    emit_signal("player_died", _player)

func _on_enemy_died(enemy):
    emit_signal("enemy_died", enemy)
